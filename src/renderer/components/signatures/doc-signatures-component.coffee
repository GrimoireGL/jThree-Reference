React = require 'react'
Radium = require 'radium'
DocSignaturesNameComponent = require './doc-signatures-name-component'
DocSignaturesTypeComponent = require './doc-signatures-type-component'
DocSignaturesParametersComponent = require './doc-signatures-parameters-component'

###
name(name?: type.name<typeArgument, ...>[], ...): type.name<typeArgument, ...>[]

@props.signature [required]
@props.name if Accessor, use this as name
@props.emphasisStyle
@props.style
###
class DocSignaturesComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <span style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        elm = []
        # name
        elm.push <DocSignaturesNameComponent base={@props.signature} emphasisStyle={@props.emphasisStyle} name={@props.name} />
        # (name?: type.name<typeArgument, ...>, ...)
        params = @props.signature.parameters
        params = [] if !params? && (@props.signature.kindString == 'Get signature' || @props.signature.kindString == 'Set signature' || @props.signature.kindString == 'Call signature')
        if params?
          elm.push <DocSignaturesParametersComponent parameters={params} emphasisStyle={@props.emphasisStyle} />
        # :
        elm.push <span>: </span>
        # name.type
        elm.push <DocSignaturesTypeComponent type={@props.signature.type} emphasisStyle={@props.emphasisStyle} />
        elm
      }
    </span>

styles =
  base: {}

DocSignaturesComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocSignaturesComponent
