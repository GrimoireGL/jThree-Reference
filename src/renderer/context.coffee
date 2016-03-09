Flux = require 'material-flux'
RouteAction = require './actions/route-action'
RouteStore = require './stores/route-store'
DocAction = require './actions/doc-action'
DocStore = require './stores/doc-store'
DocCoverageAction = require './actions/doc-coverage-action'
DocCoverageStore = require './stores/doc-coverage-store'
ExampleAction = require './actions/example-action'
ExampleStore = require './stores/example-store'
ToggleVisibilityStore = require './stores/toggle-visibility-store'
ToggleVisibilityAction = require './actions/toggle-visibility-action'


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
    @toggleVisibilityStore = new ToggleVisibilityStore(@)
    @toggleVisibilityAction = new ToggleVisibilityAction(@)
    @docCoverageStore = new DocCoverageStore(@)
    @docCoverageAction = new DocCoverageAction(@)
    @exampleStore = new ExampleStore(@)
    @exampleAction = new ExampleAction(@)

module.exports = Context
