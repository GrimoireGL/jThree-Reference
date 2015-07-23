Flux = require 'material-flux'
keys = require '../keys'
objectAssign = require 'object-assign'

class RouteStore extends Flux.Store
  ###*
   * flux store for routing
   * stores currnt fragment and route, routes for routing and root for pushState
   * @param  {Context} context flux context instance use for initializing state
   * @return {RouteStore}
  ###
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

  ###*
   * update current fragment and route
   * @param  {fragment} fragment current fragment
  ###
  route: (fragment) ->
    console.log 'route:', @state.fragment, '->', fragment
    @setState
      fragment: fragment

  ###*
   * getter for component
   * @return {Object} stored state
  ###
  get: ->
    @state

module.exports = RouteStore
