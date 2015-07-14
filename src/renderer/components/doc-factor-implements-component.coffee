React = require 'react'
Radium = require 'radium'
DocTableComponent = require './doc-table-component'
DocItemComponent = require './doc-item-component'

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
    table = table.map (o) -> [o.name]
    <DocItemComponent title={title} style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <DocTableComponent table={table} />
    </DocItemComponent>

styles =
  base: {}

DocFactorImplementsComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocFactorImplementsComponent
