React = require 'react'

class IndexComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <div>
      <h1>Index</h1>
    </div>

IndexComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = IndexComponent
