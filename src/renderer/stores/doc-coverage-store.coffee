Flux = require 'material-flux'
keys = require '../keys'
objectAssign = require 'object-assign'

class DocCoverageStore extends Flux.Store
  ###*
   * flux store for doc coverage
   * @param  {Context} context flux context instance use for initializing state
   * @return {DocStore}
  ###
  constructor: (context) ->
    super context
    @state =
      coverage: {}
    @state = objectAssign(@state, context.initialStates.DocCoverageStore)

  ###*
   * getter for component
   * @return {Object} stored state
  ###
  get: ->
    @state

module.exports = DocCoverageStore
