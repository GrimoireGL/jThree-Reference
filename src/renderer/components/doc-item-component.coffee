React = require 'react'
Radium = require 'radium'
DocTableComponent = require './doc-table-component'
colors = require './colors/color-definition'

###
@props.title [required] subtitle of this item
@props.subtitleStyle
@props.style
@props.children
###
class DocItemComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <div style={Array.prototype.concat.apply([], [styles.subtitle, @props.subtitleStyle])}>{@props.title}</div>
      {
        React.Children.map @props.children, (child) ->
          React.cloneElement child,
            style: Array.prototype.concat.apply([], [styles.content, child.props.style])
      }
    </div>

styles =
  base:
    marginBottom: 40

  subtitle:
    fontSize: 23
    fontWeight: 'bold'
    color: colors.general.r.default

  content:
    fontSize: 15
    marginTop: 15

DocItemComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocItemComponent
