React = require 'react'
Radium = require 'radium'

class ListItemComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <div style={styles.base}>
      {
        @props.children
      }
    </div>

styles =
  base:
    height: 20
    fontSize: 16

ListItemComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ListItemComponent
