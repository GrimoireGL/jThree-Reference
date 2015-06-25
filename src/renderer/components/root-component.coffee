React = require 'react'
App = require './app-component'

class RootComponent extends React.Component
  constructor: (props) ->
    super props

  getChildContext: ->
    ctx: @props.context

  render: ->
    <App />

RootComponent.childContextTypes =
  ctx: React.PropTypes.any

module.exports = RootComponent
