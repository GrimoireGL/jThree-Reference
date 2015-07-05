React = require 'react'
Radium = require 'radium'
Router = require '../lib/router'

class RouteComponent extends React.Component
  constructor: (props) ->
    super props

  _onChange: ->
    @setState @store.get()

  componentWillMount: ->
    @store = @context.ctx.routeStore
    state = @store.get()
    @setState state

    @router = new Router state.root, state.routes
    @router.setAuth state.auth

  componentDidMount: ->
    @store.onChange @_onChange.bind(@)

  componentWillUnmount: ->
    @store.removeChangeListener(@_onChange.bind(@))

  # shouldComponentUpdate: (nextProps, nextState) ->

  render: ->
    <div style={@props.style}>
      {
        console.log 'route', (+new Date()).toString()[-4..-1], @props.children.type?.displayName || @props.children.type?.name || @props.children[0]?.type?.displayName || @props.children[0]?.type?.name
        @router.route @state.fragment, @props.logined, (route, argu, default_route, fragment, default_fragment) =>
          if default_route? && default_fragment?
            @context.ctx.routeAction.navigate(fragment, {replace: true, silent: true})
          React.Children.map @props.children, (child) =>
            if child.props.route?
              match = false
              route_arr = route.split(':')
              child.props.route.split(':').forEach (r, i) ->
                if r == route_arr[i]
                  match = true
                else
                  match = false
              if match
                if @props.addClassName?
                  React.cloneElement child,
                    argu: argu
                    className: @props.addClassName
                else
                  React.cloneElement child,
                    argu: argu
              else
                if @props.addClassName?
                  React.cloneElement child,
                    argu: argu
                else
                  null
            else
              React.cloneElement child,
                argu: argu
        , (route, argu, default_route) =>
          <h1>404 NotFound</h1>
      }
    </div>

RouteComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium RouteComponent
