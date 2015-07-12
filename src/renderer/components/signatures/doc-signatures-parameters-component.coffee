React = require 'react'
Radium = require 'radium'
DocSignaturesNameComponent = require './doc-signatures-name-component'
DocSignaturesTypeComponent = require './doc-signatures-type-component'

###
(name?: type.name<typeArgument, ...>, ...)

@props.parameters [required]
###
class DocSignaturesParametersComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <span style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        elm = []
        elm.push <span>(</span>
        @props.parameters.forEach (prm, i) =>
          # name?
          elm.push <DocSignaturesNameComponent base={prm} emphasisStyle={@props.emphasisStyle} />
          # :
          elm.push <span>: </span>
          # type.name<typeArgument, ...>
          elm.push <DocSignaturesTypeComponent type={prm.type} emphasisStyle={@props.emphasisStyle} />
          # ,
          if i != @props.parameters.length - 1
            elm.push <span>, </span>
        elm.push <span>)</span>
        elm
      }
    </span>

styles =
  base: {}

  oblique:
    fontStyle: 'italic'

DocSignaturesParametersComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocSignaturesParametersComponent
