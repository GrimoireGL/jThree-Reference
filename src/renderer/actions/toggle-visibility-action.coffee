Flux = require 'material-flux'
keys = require '../keys'

class ToggleVisibilityAction extends Flux.Action
  constructor: ->
    super

  toggleVisibility: (visible, buttonKey) ->
    @dispatch 'toggleVisibility', visible, buttonKey

module.exports = ToggleVisibilityAction
