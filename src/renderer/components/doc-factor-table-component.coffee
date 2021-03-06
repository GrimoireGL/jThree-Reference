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

  componentWillMount: ->
    @store = @context.ctx.toggleVisibilityStore
    @setState @store.get()

  componentDidMount: ->
    @store.onChange =>
      @setState @store.get()

  componentWillUnmount: ->
    @store.removeAllChangeListeners()

  render: ->
    dstyle = {}
    if @props.collapsed
      dstyle =
        tb_key:
          minWidth: 210
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        table = []
        children = []
        for id, i in @props.group.children
          child = null
          for c in @props.current.children
            if c.id == id
              children.push c
        children.sort (a, b) ->
          if a.inheritedFrom && b.inheritedFrom
            return 0
          else if a.inheritedFrom && !b.inheritedFrom
            return 1;
          else if !a.inheritedFrom && b.inheritedFrom
            return -1;
        for child, i in children
          if child?
            if child.flags.isPrivate && !@state.visibility.privateVisibility
              continue
            if child.flags.isProtected && !@state.visibility.protectedVisibility
              continue
            alt_text = 'no description'
            table_row = []
            table_row.push <Link style={styles.link} uniqRoute={"class:local:.+?:#{@props.current.id}:#{child.id}"}>{child.name}</Link>
            table_row.push <span>
              {
                flags = []
                if child.flags.isPrivate
                   flags.push <span style={styles.flag} title='Private' className='icon-lock'></span>
                else if child.flags.isProtected
                   flags.push <span style={styles.flag} title='Protected' className='icon-unlock-alt'></span>
                else
                   flags.push <span style={styles.flag} title='Public' className='icon-unlock'></span>
                if child.flags.isStatic
                   flags.push <span style={styles.flag} title='Static' className='icon-thumb-tack'></span>
                flags
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

  flag:
    marginRight: 10

  link:
    color: colors.general.r.emphasis
    textDecoration: 'none'
    cursor: 'pointer'

    ':hover':
      textDecoration: 'underline'

DocFactorTableComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocFactorTableComponent
