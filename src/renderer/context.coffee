Flux = require 'material-flux'
RouteAction = require './actions/route-action'
RouteStore = require './stores/route-store'
DocAction = require './actions/doc-action'
DocStore = require './stores/doc-store'
OverviewAction = require './actions/overview-action'
OverviewStore = require './stores/overview-store'


class Context extends Flux.Context
  ###*
   * construct context for flux
   * @param  {Object} initialStates initialize state for stores
   * @return {Context}
  ###
  constructor: (initialStates) ->
    super
    @initialStates = initialStates
    @routeAction = new RouteAction(@)
    @routeStore = new RouteStore(@)
    @docAction = new DocAction(@)
    @docStore = new DocStore(@)
    @overviewStore = new OverviewStore(@)
    @overviewAction = new OverviewAction(@)

module.exports = Context
