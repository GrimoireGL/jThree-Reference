React = require 'react'
Radium = require 'radium'

class CharIconComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <span style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        if @props.char?
          <span>{@props.char}</span>
        else if @props.icomoon?
          <span className={"icon-#{@props.icomoon}"}></span>
        else
          null
      }
    </span>

styles =
  base:
    display: 'inline-block'
    width: 18
    height: 18
    borderWidth: 1
    borderStyle: 'solid'
    borderColor: '#000'
    marginTop: 4
    marginRight: 10
    textAlign: 'center'

CharIconComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium CharIconComponent
