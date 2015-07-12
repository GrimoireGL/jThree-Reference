React = require 'react'
Radium = require 'radium'
DocSignaturesTypeargumentsComponent = require './doc-signatures-typearguments-component'

###
name?

@props.base [required]
@props.name if Accessor, use this as name
###
class DocSignaturesNameComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <span style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        elm = []
        # get|set
        if @props.base.kindString == 'Get signature'
          elm.push <span>get </span>
        else if @props.base.kindString == 'Set signature'
          elm.push <span>set </span>
        # name
        name = @props.base.name
        name = @props.name if @props.base.kindString == 'Get signature' || @props.base.kindString == 'Set signature'
        elm.push <span style={@props.emphasisStyle}>{name}</span>
        # ?
        if @props.base.defaultValue? || @props.base.flags?.isOptional == true
          elm.push <span>{'?'}</span>
        elm
      }
    </span>

styles =
  base: {}

  oblique:
    fontStyle: 'italic'

DocSignaturesNameComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocSignaturesNameComponent
