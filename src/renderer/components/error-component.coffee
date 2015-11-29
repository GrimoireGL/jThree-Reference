React = require 'react'

class ErrorComponent extends React.Component
  
  constructor: (props) ->
    super props

  render: ->
    <div>
      <h1>404 NotFound</h1>
    </div>

ErrorComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = ErrorComponent
