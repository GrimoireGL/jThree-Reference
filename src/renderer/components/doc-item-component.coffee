React = require 'react'
Radium = require 'radium'
DocTableComponent = require './doc-table-component'

class DocItemComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <div style={styles.subtitle}>{@props.group.title}</div>
      <DocTableComponent group={@props.group} current={@props.current} style={styles.content} />
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
