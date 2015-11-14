objectAssign = require 'object-assign'

class RoutesGen
  ###*
   * Routes generator
   * @param  {Object} json typedoc json
   * @return {RoutesGen}
  ###
  constructor: (json) ->
    @routes = {}
    @_constructRoutes json

  ###*
   * regenerate routes
   * @param  {Object} json typedoc json
   * @return {Object}      routes
  ###
  gen: (classJson, overviewCount) ->
    @_constructRoutes classJson, overviewCount

  ###*
   * construct routes
   * @param  {Object} json typedoc json
   * @return {Object}      merged fragment of routes
  ###
  _constructRoutes: (classJson, overviewCount) ->
    @routes = {}
    @routes = objectAssign {}, @routes, constructClassRoutes(classJson)
    @routes = objectAssign {}, @routes, constructIndexRoutes()
    @routes = objectAssign {}, @routes, constructOverviewRoutes(overviewCount)
    @routes = objectAssign {}, @routes, constructErrorRoutes()

  ###*
   * construct class route
   * @param  {Object} json typedoc json
   * @return {Object}      fragment of routes
  ###
  constructClassRoutes = (json) ->
    prefix = 'class'
    routes = {}
    json?.children?.forEach (child, i) ->
      dir = child.name.replace(/\"/g, '')
      dir_arr = dir.split('/')
      dir_arr.forEach (d, j) ->
        if j != dir_arr.length - 1
          routes["#{prefix}/#{dir_arr[0..j].join('/')}"] = "#{prefix}:global"
        else
          child.children?.forEach (gchild) ->
            routes["#{prefix}#{if dir_arr.length == 1 then '' else '/' + dir_arr[0..(j - 1)].join('/')}/#{gchild.name}"] = "#{prefix}:global:#{child.id}:#{gchild.id}"
            gchild.children?.forEach (ggchild) ->
              routes["#{prefix}#{if dir_arr.length == 1 then '' else '/' + dir_arr[0..(j - 1)].join('/')}/#{gchild.name}/#{ggchild.name}"] = "#{prefix}:local:#{child.id}:#{gchild.id}:#{ggchild.id}"
    routes["#{prefix}"] = "#{prefix}"
    return routes

  ###*
   * construct index route
   * @return {Object} fragment of routes
  ###
  constructIndexRoutes = ->
    routes =
      '' : 'index'
    return routes

  ###*
   * construct overview route
   * @return {Object} fragment of routes
  ###
  constructOverviewRoutes = (count) ->
    routes =
      'overview': 'overview'
    [0..count].forEach (v) ->
      routes["overview/#{v}"] = "overview:#{v}"
    return routes

  ###*
   * construct error routes
   * @return {Object} fragment of routes
  ###
  constructErrorRoutes = ->
    routes =
      '.*' : 'error'
    return routes

module.exports = RoutesGen
