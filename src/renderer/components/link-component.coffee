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

-- By specifying path including RegExp
If @props.to is specified, seach path by using RegExp from RouteStore and give set to component's href attribute.
Warning: routes are not always up-to-date because @state.routes is not link to
RouteStore state due to a performance probrem.

Example:
<Link to='/.* /deeppage'>DeepPage</Link>

-- By specifying unique route
If @props.uniqRoute is specified, search path by using RegExp from RouteStore and give set to component's
href attribute.
Warning: Even if uniqRoute is not unique, path(for exapmle '.*' including regexp
in the path) is permanently set to href.
Warning: routes are not always up-to-date because @state.routes is not link to
RouteStore state due to a performance probrem.

Example:
<Link uniqRoute='index'>Index</Link>

###

class LinkComponent extends React.Component
  constructor: (props) ->
    super props

  componentWillMount: ->
    if @props.uniqRoute || @props.to
      @setState
        routes: @context.ctx.routeStore.get().routes
    @href = '#'

  navigate: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @context.ctx.routeAction.navigate(@href)

  render: ->
    @href = '#'
    if @props.href
      @href = @props.href
    else if @props.to
      for fragment, route of @state.routes
        if fragment.match new RegExp("^#{@props.to.replace(/^\//, '').replace(/\//g, '\/')}$")
          @href = "/#{fragment}"
          break
    else if @props.uniqRoute?
      for fragment, route of @state.routes
        if route.match new RegExp("^#{@props.uniqRoute}$")
          @href = "/#{fragment}"
          break
    <a href={@href} onClick={@navigate.bind(@)} style={@props.style}>
      {@props.children}
    </a>

LinkComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium LinkComponent
