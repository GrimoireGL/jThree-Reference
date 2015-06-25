Flux = require 'material-flux'
keys = require '../keys'
objectAssign = require 'object-assign'

class RouteStore extends Flux.Store
  constructor: (context) ->
    super context
    @state =
      fragment: '/'
      root: '/'
      routes: null
      auth: null
    @state = objectAssign(@state, context.initialStates.RouteStore)
    @register keys.route, @route
    if !@state.routes?
      throw new Error('state.routes must be specifyed by initialState.')

  route: (fragment) ->
    console.log 'route:', @state.fragment, '->', fragment
    @setState
      fragment: fragment

  get: ->
    @state

module.exports = RouteStore
