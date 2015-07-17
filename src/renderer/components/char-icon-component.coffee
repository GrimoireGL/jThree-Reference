React = require 'react'
Radium = require 'radium'

class CharIconComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    # console.log "render CharIcon", (+new Date()).toString()[-4..-1]
    dstyle = {}
    if @props.char?.length >= 2
      dstyle.base =
        width: 'auto'
        paddingLeft: 8
        paddingRight: 8
    <span style={Array.prototype.concat.apply([], [styles.base, @props.style, dstyle.base])}>
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
    fontSize: 13

CharIconComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium CharIconComponent
