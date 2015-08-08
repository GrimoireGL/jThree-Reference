objectAssign = require 'object-assign'

class Router
  ###*
   * Routing support for flux architecture
   * @param  {String} root   root path for pushState
   * @param  {Object} routes object that contains routes corresponed to fragments
   * @return {Router}
  ###
  constructor: (root, routes) ->
    root = '/'
    @routes = {}
    @auth = {}
    @setRoot root
    @setRoute routes

  ###*
   * set root path for pushState
   * @param {String} root root path for pushState
  ###
  setRoot: (root) ->
    @root = if root? && root != '/' then '/' + @clearSlashes(root) + '/' else '/'

  ###*
   * set object that contains routes corresponed to fragments
   * @param {Object} routes object that contains routes corresponed to fragments
  ###
  setRoute: (routes) ->
    @routes = routes if routes?

  ###*
   * add routes
   * @param {String|Object} path fragment; if Object is specifyed, object is used as fragment of routes
   * @param {String?} route      route
  ###
  addRoute: (path, route) ->
    if path?
      unless route?
        routes = path
      else
        routes = {}
        routes[path] = route
      @routes = objectAssign(@routes, routes)

  ###*
   * set routes for authenticated only
   * @param {String|Object} route if required and renavigate is not specifyed, object is set as unit of auth
   * @param {Boolean} required    if true, renavigate when not authorized. if false, renavigate when authorized
   * @param {String} renavigate   path of renavigation(like redirect)
  ###
  setAuth: (route, required, renavigate) ->
    auth = {}
    if route? && !required? && !renavigate?
      auth = route
    else if route? && required? && renavigate?
      auth[route] =
        required: required
        renavigate: renavigate
    @auth = objectAssign @auth, auth

  ###*
   * routing process
   * @param  {String} fragment  fragment of path to route
   * @param  {Boolean} logined  authenticated or not
   * @param  {Function} resolve callback function called when routing succeeded
   * @param  {Function} reject  callback function called when routing failed
   * @return {Any}              returned from callback function
  ###
  route: (fragment, logined, resolve, reject) ->
    if typeof logined == 'function' && !reject?
      reject = resolve
      resolve = logined
      logined = undefined

    fragment = fragment.replace /\?(.*)$/, ''
    fragment = @clearSlashes(fragment.replace(new RegExp("^#{@root}"), ''))
    res = []
    for re, r of @routes
      match = fragment.match new RegExp("^#{re}$")
      if match?
        match.shift()
        delete match.index
        delete match.input
        argu = {}
        argu.route = r
        argu.route_arr = r.split(':')
        argu.fragment = fragment
        argu.fragment_arr = fragment.split('/')
        argu.match = match
        if logined?
          auth = null
          for r_, a of @auth
            if (r_.split(':').every (v, i) -> argu.route_arr[i] == v)
              auth = a
          if (auth?.required == true && !logined) || (auth?.required == false && logined)
            if auth.renavigate?
              for re_, r_ of @routes
                match_ = auth.renavigate.match new RegExp("^#{re_}$")
                if match_?
                  match_.shift()
                  delete match_.index
                  delete match_.input
                  argu = {}
                  argu.route = r_
                  argu.route_arr = r_.split(':')
                  argu.fragment = auth.renavigate
                  argu.fragment_arr = auth.renavigate.split('/')
                  argu.match = match_
                  return resolve?(r_, argu, r, auth.renavigate, fragment)
              console.warn('\'renavigate\' fragment is not found in routes.')
            else
              console.warn('\'renavigate\' is not specified in authenticated route.')
        return resolve?(r, argu, null, fragment, null)
    return reject?(null, [], null, fragment, null)

  clearSlashes: (path) ->
    path.toString().replace(/\/$/, '').replace(/^\//, '')

module.exports = Router
