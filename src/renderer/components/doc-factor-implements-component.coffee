React = require 'react'
Radium = require 'radium'
DocSignaturesTypeComponent = require './signatures/doc-signatures-type-component'
DocTableComponent = require './doc-table-component'
DocItemComponent = require './doc-item-component'
colors = require './colors/color-definition'

###
@props.current [required] current factor
@props.style
###
class DocFactorImplementsComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    title = ''
    table = []
    if @props.current.implementedTypes?
      title = 'Implements'
      table = @props.current.implementedTypes
    else if @props.current.implementedBy?
      title = 'Implemented by'
      table = @props.current.implementedBy
    table = table.map (o) ->
      [<span style={styles.type}><DocSignaturesTypeComponent type={o} emphasisStyle={styles.emphasis} /></span>]
    <DocItemComponent title={title} style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <DocTableComponent table={table} />
    </DocItemComponent>

styles =
  base: {}

  type:
    color: colors.general.r.light

  emphasis:
    color: colors.general.r.default

DocFactorImplementsComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocFactorImplementsComponent
