Flux = require 'material-flux'
keys = require '../keys'
objectAssign = require 'object-assign'

class ToggleVisibilityStore extends Flux.Store
  constructor: (context) ->
    super context
    @state =
      visibility:
        privateVisibility: false
        protectedVisibility: true
    @state = objectAssign(@state, context.initialStates.ToggleVisibilityStore)
    #
    # state restoration from cookie should be implimented HERE
    #
    @register keys.toggleVisibility, @toggleVisibility

  toggleVisibility: (visible, buttonKey) ->
    visibility = @state.visibility
    visibility[buttonKey] = visible
    @setState
      visibility: visibility

  get: ->
    @state

module.exports = ToggleVisibilityStore
