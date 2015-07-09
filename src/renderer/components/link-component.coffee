React = require 'react'
Radium = require 'radium'

###
Routing support component

*** Props ***
@props.href {obj|array} url path of link location
@props.style {obj|array} this style object or array of it

*** Usage ***

-- General Usage
Specify url path to @props.href same as <a> tag, then navigate path on clicking.
If you want to navigate other pages except relative route, normaly use <a> tag.

Example:
<Link href='/index'>Index</Link>

###

class LinkComponent extends React.Component
  constructor: (props) ->
    super props

  navigate: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @context.ctx.routeAction.navigate(@props.href)

  render: ->
    <a href={@props.href} onClick={@navigate.bind(@)} style={@props.style}>
      {@props.children}
    </a>

LinkComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium LinkComponent
