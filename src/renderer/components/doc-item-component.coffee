React = require 'react'
Radium = require 'radium'
DocTableComponent = require './doc-table-component'

class DocItemComponent extends React.Component
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
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style, dstyle.base])}>
      <div style={[styles.subtitle, dstyle.subtitle]}>{@props.group.title}</div>
      <DocTableComponent group={@props.group} current={@props.current} style={[styles.content, dstyle.content]} collapsed={@props.collapsed} />
    </div>

styles =
  base:
    marginBottom: 40

  subtitle:
    fontSize: 23
    fontWeight: 'bold'

  content:
    fontSize: 15
    marginTop: 15

DocItemComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocItemComponent
