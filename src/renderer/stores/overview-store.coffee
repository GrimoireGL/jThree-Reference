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
    @state = objectAssign(@state, context.initialStates.OverviewStore)
    @register keys.updateOverview, @updateOverview

  ###*
   * update overview's markdown 
   * @param  {String} markdown 
  ###
  updateOverview: (markdown) ->
    console.log markdown
    md = @state.markdown
    @setState markdown: md

  ###*
   * getter for component
   * @return {Object} stored state
  ###
  get: ->
    @state

module.exports = OverviewStore
