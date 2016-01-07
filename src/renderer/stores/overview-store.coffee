Flux = require 'material-flux'
keys = require '../keys'
objectAssign = require 'object-assign'

class OverviewStore extends Flux.Store
  ###*
   * flux store for overview
   * stores markup for overview page
   * @param  {Context} context flux context instance use for initializing state
   * @return {OverviewStore}
  ###
  constructor: (context) ->
    super context
    @state =
      markup: {}
      structure: []
    @state = objectAssign(@state, context.initialStates.OverviewStore)
    @register keys.updateOverview, @updateOverview

  ###*
   * update overview's markup,structure
   * @param data.markup {string}
  ###
  updateOverview: (path, data) ->
    state = markup:{}
    state.markup[path.replace(/:::/g, "/")] = data.markup
    state.structure = data.structure
    console.log state
    @setState objectAssign(@state, state)

  ###*
   * getter for component
   * @return {Object} stored state
  ###
  get: ->
    @state

module.exports = OverviewStore
