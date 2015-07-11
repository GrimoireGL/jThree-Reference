React = require 'react'
Radium = require 'radium'
DocItemComponent = require './doc-item-component'

###
@props.text description text
###
class DocDescriptionComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    # alt_text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Incidunt libero, suscipit, rerum id ipsum provident voluptas deleniti dolor dignissimos nostrum, deserunt, vel voluptatem a. Nostrum rerum illum cum reiciendis quisquam! Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ipsa distinctio iure recusandae sapiente voluptatibus. Nobis corporis architecto numquam quibusdam, culpa quaerat voluptates, incidunt saepe dolore, velit distinctio placeat sequi accusantium."[0..Math.round(Math.random() * 478)]
    alt_text = 'no description'
    <DocItemComponent title='Description' style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <div style={styles.content}>{@props.text ? alt_text}</div>
    </DocItemComponent>

styles =
  base: {}

  content:
    color: '#333'

DocDescriptionComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocDescriptionComponent
