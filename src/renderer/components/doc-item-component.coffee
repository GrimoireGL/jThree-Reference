React = require 'react'
Radium = require 'radium'
DocTableComponent = require './doc-table-component'

###
@props.title [required] subtitle of this item
@props.style
@props.children
###
class DocItemComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <div style={styles.subtitle}>{@props.title}</div>
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

  content:
    fontSize: 15
    marginTop: 15

DocItemComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocItemComponent
