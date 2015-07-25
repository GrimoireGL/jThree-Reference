React = require 'react'
Radium = require 'radium'
Link = require './link-component'
DocTableComponent = require './doc-table-component'
colors = require './colors/color-definition'

###
@props.group [required] parent of current factor
@props.current [required] current factor
@prrops.collapsed [required]
@props.style
###
class DocFactorTableComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    dstyle = {}
    if @props.collapsed
      dstyle =
        tb_key:
          minWidth: 210
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        table = []
        for id, i in @props.group.children
          child = null
          for c in @props.current.children
            if c.id == id
              child = c
          if child?
            alt_text = 'no description'
            table_row = []
            table_row.push <Link style={styles.link} uniqRoute={"class:local:.+?:#{@props.current.id}:#{child.id}"}>{child.name}</Link>
            table_row.push <span>
              {
                if child.flags.isPrivate
                  'Private'
                else if child.flags.isProtected
                  'Protected'
                else if child.flags.isStatic
                  'Static'
              }
            </span>
            table_row.push <span>{child.comment?.shortText || child.signatures?[0].comment?.shortText || child.getSignature?[0].comment?.shortText || child.setSignature?[0].comment?.shortText || alt_text}</span>
            table.push table_row
        cellStyles = [dstyle.tb_key, undefined]
        <DocTableComponent prefix="#{@props.current.id}-#{@props.group.kind}" table={table} cellStyles={cellStyles} />
      }
    </div>

styles =
  base: {}

  link:
    color: colors.general.r.emphasis
    textDecoration: 'none'
    cursor: 'pointer'

    ':hover':
      textDecoration: 'underline'

DocFactorTableComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocFactorTableComponent
