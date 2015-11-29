Flux = require 'material-flux'
keys = require '../keys'
objectAssign = require 'object-assign'

class OverviewStore extends Flux.Store
  ###*
   * flux store for overview
   * stores markdown for overview page
   * @param  {Context} context flux context instance use for initializing state
   * @return {OverviewStore}
  ###
  constructor: (context) ->
    super context
    @state =
      markdown: ""
      structure: []
    @state = objectAssign(@state, context.initialStates.OverviewStore)
    @register keys.updateOverview, @updateOverview

  ###*
   * update overview's markdown,structure
   * @param data.markdown {string}
  ###
  updateOverview: (data) ->
    @setState objectAssign(@state, data)
    console.log @state

  ###*
   * getter for component
   * @return {Object} stored state
  ###
  get: ->
    @state

module.exports = OverviewStore
