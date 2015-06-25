Flux = require 'material-flux'
keys = require '../keys'
objectAssign = require 'object-assign'

class DocStore extends Flux.Store
  constructor: (context) ->
    super context
    @state =
      dir_tree: {}
      doc_data: {}
    @state = objectAssign(@state, context.initialStates.DocStore)
    @register keys.updateDoc, @updateDoc

  updateDoc: (id, data) ->
    doc_data = @state.doc_data
    doc_data[id.toString()] = data
    @setState
      doc_data: doc_data

  get: ->
    @state

module.exports = DocStore
