React = require 'react'
Radium = require 'radium'
Link = require './link-component'
DocTableComponent = require './doc-table-component'
colors = require './colors/color-definition'
DocSignaturesTypeComponent = require './signatures/doc-signatures-type-component'

###
@props.current [required] local current which is child of current factor
###
class DocDetailParameterTableComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        table = []
        for prm, i in @props.current.signatures[0].parameters
          alt_text = 'no description'
          table_row = []
          table_row.push <span>{prm.name}</span>
          table_row.push <span style={styles.type}><DocSignaturesTypeComponent type={prm.type} emphasisStyle={styles.emphasis} /></span>
          table_row.push <span>{prm.comment?.shortText || prm.comment?.text || alt_text}</span>
          table.push table_row
        <DocTableComponent prefix="#{@props.current.id}-prm" table={table} />
      }
    </div>

styles =
  base: {}

  type:
    color: colors.general.r.light

  emphasis:
    color: colors.general.r.default

  link:
    color: colors.general.r.emphasis
    textDecoration: 'none'
    cursor: 'pointer'

    ':hover':
      textDecoration: 'underline'

DocDetailParameterTableComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocDetailParameterTableComponent
