React = require 'react'
Radium = require 'radium'
DocDetailParametersTableComponent = require './doc-detail-parameters-table-component'
DocItemComponent = require './doc-item-component'

###
@props.current [required] current factor or local current which is child of current factor
@props.style
###
class DocTypeparameterComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <DocItemComponent title='Type parameters' style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <DocDetailParametersTableComponent parameters={@props.current.typeParameter} current_id={@props.current.id} />
    </DocItemComponent>

styles =
  base: {}

DocTypeparameterComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocTypeparameterComponent
