React = require 'react'
Radium = require 'radium'

class LinkComponent extends React.Component
  constructor: (props) ->
    super props

  navigate: (e) ->
    e.preventDefault()
    @context.ctx.routeAction.navigate(@props.href)

  render: ->
    <a href={@props.href} onClick={@navigate.bind(@)} style={@props.style}>
      {@props.children}
    </a>

LinkComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium LinkComponent
