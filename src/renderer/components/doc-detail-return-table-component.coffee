React = require 'react'
Radium = require 'radium'
Link = require './link-component'
DocTableComponent = require './doc-table-component'
colors = require './colors/color-definition'

###
@props.current [required] local current which is child of current factor
@props.style
###
class DocDetailReturnTableComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        table = []
        alt_text = 'no description'
        table_row = []
        prm = @props.current.signatures?[0] || @props.current.getSignature?[0] || @props.current.setSignature?[0]
        elm = []
        elm.push <span style={[styles.emphasis, styles.oblique]}>{prm.type.name}</span>
        if prm.type.typeArguments?
          elm.push <span>{'<'}</span>
          prm.type.typeArguments.forEach (targ, i) ->
            elm.push <span style={[styles.emphasis, styles.oblique]}>{targ.name}</span>
            if i != prm.type.typeArguments.length - 1
              elm.push <span>, </span>
          elm.push <span>{'>'}</span>
        if prm.type.isArray
          elm.push <span>[]</span>
        table_row.push <span style={styles.type}>{elm}</span>
        table_row.push <span>{@props.current.comment?.returns || @props.current.signatures?[0].comment?.returns || @props.current.getSignature?[0].comment?.returns || @props.current.setSignature?[0].comment?.returns || alt_text}</span>
        table.push table_row
        <DocTableComponent prefix="#{@props.current.id}-rtn" table={table} />
      }
    </div>

styles =
  base: {}

  type:
    color: colors.general.r.light

  oblique:
    fontStyle: 'italic'

  emphasis:
    color: colors.general.r.default

  link:
    color: colors.general.r.emphasis
    textDecoration: 'none'
    cursor: 'pointer'

    ':hover':
      textDecoration: 'underline'

DocDetailReturnTableComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocDetailReturnTableComponent
