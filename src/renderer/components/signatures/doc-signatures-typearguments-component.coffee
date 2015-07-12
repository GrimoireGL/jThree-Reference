React = require 'react'
Radium = require 'radium'

###
<typeArguments, ...>

@props.typeArguments [required]
###
class DocSignaturesTypeargumentsComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <span style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        elm = []
        # <
        elm.push <span>{'<'}</span>
        # typeArguments, ...
        @props.typeArguments.forEach (targ, i) ->
          elm.push <span style={[@props.emphasisStyle, styles.oblique]}>{targ.name}</span>
          if i != @props.typeArguments.length - 1
            elm.push <span>, </span>
        # >
        elm.push <span>{'>'}</span>
        elm
      }
    </span>

styles =
  base: {}

  oblique:
    fontStyle: 'italic'

DocSignaturesTypeargumentsComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocSignaturesTypeargumentsComponent
