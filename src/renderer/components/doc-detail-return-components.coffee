React = require 'react'
Radium = require 'radium'
DocDetailReturnTableComponent = require './doc-detail-return-table-component'
DocItemComponent = require './doc-item-component'

###
@props.current [required] local current which is child of current factor
###
class DocDetailReturnComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <DocItemComponent title='Returns' style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <DocDetailReturnTableComponent current={@props.current} style={[styles.content]} />
    </DocItemComponent>

styles =
  base: {}
  content: {}

DocDetailReturnComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocDetailReturnComponent
