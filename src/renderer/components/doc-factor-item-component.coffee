React = require 'react'
Radium = require 'radium'
DocFactorTableComponent = require './doc-factor-table-component'
DocItemComponent = require './doc-item-component'

###
@props.group [required] parent of current factor
@props.current [required] current factor
@props.collapsed [required]
@props.style
###
class DocFactorItemComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    dstyle = {}
    if @props.collapsed
      dstyle =
        base:
          marginBottom: 30
        subtitle:
          marginLeft: 0
          fontSize: 15
        content:
          marginTop: 8
    <DocItemComponent title={@props.group.title} style={Array.prototype.concat.apply([], [@props.style, dstyle.base])} subtitleStyle={dstyle.subtitle}>
      <DocFactorTableComponent group={@props.group} current={@props.current} style={[dstyle.content]} collapsed={@props.collapsed} />
    </DocItemComponent>

DocFactorItemComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocFactorItemComponent
