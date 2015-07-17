React = require 'react'
Radium = require 'radium'
Link = require './link-component'
colors = require './colors/color-definition'

###
@props.title [required]
@props.kindString [required]
@props.children
@props.dstyle
@props.style
###
class DocTitleComponent extends React.Component
  constructor: (props) ->
    super props

  genKindStringStyle: (kindString) ->
    color = colors.general.r.default

    switch kindString
      when 'Class'
        color = '#337BFF'
      when 'Constructor'
        color = '#337BFF'
      when 'Interface'
        color = '#598213'
      when 'Property'
        color = '#598213'
      when 'Enumeration'
        color = '#B17509'
      when 'Enumeration member'
        color = '#B17509'
      when 'Module'
        color = '#D04C35'
      when 'Accessor'
        color = '#D04C35'
      when 'Function'
        color = '#6E00FF'
      when 'Method'
        color = '#6E00FF'
      else
        color = colors.general.r.default

    style =
      color: color
      borderColor: color

  render: ->
    dstyle = if @props.dstyle? then @props.dstyle else {}
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style, dstyle.base])}>
      <div style={styles.title_wrap}>
        <div style={[styles.kind_string, @genKindStringStyle(@props.kindString), dstyle.kind_string]}>{@props.kindString}</div>
        <div style={[styles.title, dstyle.title]}>{@props.title}</div>
      </div>
      <div style={styles.info}>
        {@props.children}
      </div>
    </div>

styles =
  base:
    marginBottom: 40

  title_wrap:
    overflow: 'hidden'
    marginBottom: 10

  kind_string:
    fontSize: 18
    borderStyle: 'solid'
    borderWidth: 1
    paddingTop: 6
    paddingBottom: 6
    paddingLeft: 12
    paddingRight: 12
    marginTop: 3
    marginRight: 10
    float: 'left'

  title:
    fontSize: 35
    paddingLeft: 12
    paddingRight: 12
    color: colors.general.r.emphasis
    float: 'left'
    fontWeight: 'bold'

  info:
    fontSize: 15
    color: colors.general.r.light

DocTitleComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocTitleComponent
