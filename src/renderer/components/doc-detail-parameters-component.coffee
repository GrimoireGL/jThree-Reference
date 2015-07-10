React = require 'react'
Radium = require 'radium'
DocDetailTableComponent = require './doc-detail-table-component'
DocItemComponent = require './doc-item-component'

###
@props.current [required] local current which is child of current factor
###
class DocDetailParametersComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <DocItemComponent title='Parameters' style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <DocDetailTableComponent current={@props.current} style={[styles.content]} />
    </DocItemComponent>

styles =
  base: {}
  content: {}

DocDetailParametersComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocDetailParametersComponent
