Flux = require 'material-flux'
keys = require '../keys'
History = null
History = require 'html5-history' if window?

class RouteAction extends Flux.Action
  ###*
   * flux action for routing
   * @return {RouteAction}
  ###
  constructor: ->
    super
    if History?.Adapter?
      History.Adapter.bind window, 'statechange' , =>
        state = History.getState()
        @dispatch(keys.route, state.hash)
    else
      console.warn 'html5-history is not available.' if window?

  ###*
   * route navigation
   * @param  {String} path    navigation path
   * @param  {Object} options option.silent is specifyed, only replace location bar and no page transfer
  ###
  navigate: (path, options) ->
    if path[0] != '/'
      path = "#{document.location.pathname}/#{@clearSlashes path}"
    else
      path = "/#{@clearSlashes path}"
    if History?.Adapter?
      if options?.replace == true
        History.replaceState null, null, path, undefined, options?.silent
      else
        History.pushState null, null, path, undefined, options?.silent
    else if location?
      location.href = path

  ###*
   * strip slashes
   * @param  {String} path
   * @return {String}      slashes striped path
  ###
  clearSlashes: (path) ->
    path.toString().replace(/\/$/, '').replace(/^\//, '')

module.exports = RouteAction
