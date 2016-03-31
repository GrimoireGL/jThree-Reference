React = require 'react'
Radium = require 'radium'

class ExampleSidebarItemComponent extends React.Component

  constructor: (props) ->
    super props

  render: ->
    width = @props?.width || 256
    height = @props?.height || 256
    <div>
      <object type="image/svg+xml" data="/static/img/loading.svg" width={width} height={height}></object>
    </div>


ExampleSidebarItemComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ExampleSidebarItemComponent
