Flux = require 'material-flux'
keys = require '../keys'
History = null
History = require 'html5-history' if window?

class RouteAction extends Flux.Action
  constructor: ->
    super
    if History?.Adapter?
      History.Adapter.bind window, 'statechange' , =>
        state = History.getState()
        @dispatch(keys.route, state.hash)
    else
      console.warn 'html5-history is not available.' if window?

  navigate: (path, options) ->
    path = "/#{@clearSlashes path}"
    if History?.Adapter?
      if options?.replace == true
        History.replaceState null, null, path, undefined, options?.silent
      else
        History.pushState null, null, path, undefined, options?.silent
    else if location?
      location.href = path

  clearSlashes: (path) ->
    path.toString().replace(/\/$/, '').replace(/^\//, '')

module.exports = RouteAction
