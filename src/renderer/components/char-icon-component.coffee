React = require 'react'
Radium = require 'radium'

class CharIconComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <span style={[styles.base, @props.style]}>
      {@props.char}
    </span>

styles =
  base:
    display: 'inline-block'
    width: 18
    height: 18
    borderWidth: 1
    borderStyle: 'solid'
    borderColor: '000'
    marginRight: 10
    textAlign: 'center'

CharIconComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium CharIconComponent
