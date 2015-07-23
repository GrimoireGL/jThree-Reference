Flux = require 'material-flux'
keys = require '../keys'
objectAssign = require 'object-assign'
merge = require 'lodash.merge'

class DocStore extends Flux.Store
  ###*
   * flux store for doc
   * stores doc objects and tree formed structure of doc
   * @param  {Context} context flux context instance use for initializing state
   * @return {DocStore}
  ###
  constructor: (context) ->
    super context
    @state =
      dir_tree: {}
      doc_data: {}
    @state = objectAssign(@state, context.initialStates.DocStore)
    @register keys.updateDoc, @updateDoc

  ###*
   * update doc objects
   * @param  {Object} data fragment of doc data
  ###
  updateDoc: (data) ->
    doc_data = @state.doc_data
    doc_data = merge {}, doc_data, data
    @setState
      doc_data: doc_data

  ###*
   * getter for component
   * @return {Object} stored state
  ###
  get: ->
    @state

module.exports = DocStore
