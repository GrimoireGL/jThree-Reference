Flux = require 'material-flux'
RouteAction = require './actions/route-action'
RouteStore = require './stores/route-store'
DocAction = require './actions/doc-action'
DocStore = require './stores/doc-store'

class Context extends Flux.Context
  constructor: (initialStates) ->
    super
    @initialStates = initialStates
    @routeAction = new RouteAction(@)
    @routeStore = new RouteStore(@)
    @docAction = new DocAction(@)
    @docStore = new DocStore(@)

module.exports = Context
