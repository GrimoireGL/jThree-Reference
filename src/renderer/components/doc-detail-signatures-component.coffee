React = require 'react'
Radium = require 'radium'
DocSignaturesComponent = require './signatures/doc-signatures-component'
colors = require './colors/color-definition'

class DocDetailSignaturesComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style, styles.code])}>
      {
        elm = []
        if @props.current.signatures?
          @props.current.signatures.forEach (s) ->
            elm.push <DocSignaturesComponent signature={s} emphasisStyle={styles.emphasis} />
        else if @props.current.getSignature? || @props.current.setSignature?
          @props.current.getSignature?.forEach (s) =>
            elm.push <DocSignaturesComponent signature={s} emphasisStyle={styles.emphasis} name={@props.current.name} />
          @props.current.setSignature?.forEach (s) =>
            elm.push <DocSignaturesComponent signature={s} emphasisStyle={styles.emphasis} name={@props.current.name} />
        else
          elm.push <DocSignaturesComponent signature={@props.current} emphasisStyle={styles.emphasis} />

        elm.map (e, i) ->
          signature_style = {}
          if i != elm.length - 1
            signature_style =
              borderBottomWidth: 1
              borderBottomStyle: 'solid'
              borderBottomColor: '#555'
          <div style={[signature_style, styles.signature]}>{e}</div>
      }
    </div>

styles =
  base:
    backgroundColor: colors.inverse.n.default
    paddingTop: 2
    paddingBottom: 3
    paddingLeft: 50
    paddingRight: 50
    marginRight: -50
    marginLeft: -50
    color: colors.inverse.r.moderate

  signature:
    paddingTop: 12
    paddingBottom: 11

  emphasis:
    color: colors.inverse.r.emphasis

  oblique:
    fontStyle: 'italic'

  code:
    fontFamily: 'Menlo, Monaco, Consolas, "Courier New", monospace'
    fontSize: 13

DocDetailSignaturesComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocDetailSignaturesComponent
