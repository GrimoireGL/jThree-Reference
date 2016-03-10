Flux = require 'material-flux'
keys = require '../keys'
objectAssign = require 'object-assign'

class ExampleStore extends Flux.Store
  ###*
   * flux store for example
   * stores markup for example page
   * @param  {Context} context flux context instance use for initializing state
   * @return {ExampleStore}
  ###
  constructor: (context) ->
    super context
    @state =
      markup: {}
      structure: []
    @state = objectAssign(@state, context.initialStates.ExampleStore)
    @register keys.updateExample, @updateExample

  ###*
   * update example's markup,structure
   * @param data.markup {string}
  ###
  updateExample: (path, data) ->
    state = markup:{}
    state.markup[path.replace(/\?/g, "/")] = data.markup
    state.structure = data.structure
    console.log state
    @setState objectAssign(@state, state)

  ###*
   * getter for component
   * @return {Object} stored state
  ###
  get: ->
    @state

module.exports = ExampleStore
