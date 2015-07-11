React = require 'react'
Radium = require 'radium'
colors = require './colors/color-definition'

class DocTitleComponent extends React.Component
  constructor: (props) ->
    super props

  genKindStringStyle: (kindString) ->
    color = colors.general.r.default

    switch kindString
      when 'Class'
        color = '#337BFF'
      when 'Interface'
        color = '#598213'
      when 'Enumeration'
        color = '#B17509'
      when 'Module'
        color = '#D04C35'
      when 'Function'
        color = '#6E00FF'
      else
        color = colors.general.r.default

    style =
      color: color
      borderColor: color

  render: ->
    dstyle = {}
    if @props.collapsed
      dstyle =
        base:
          marginBottom: 30

        kind_string:
          fontSize: 14
          paddingTop: 3
          paddingBottom: 1
          paddingLeft: 12
          paddingRight: 12
          marginLeft: 0
          marginRight: 12
          textAlign: 'center'
          float: 'none'
          display: 'inline-block'

        title:
          fontSize: 20
          paddingLeft: 0
          paddingRight: 0
          float: 'none'
          marginTop: 10
          marginLeft: 0

    <div style={Array.prototype.concat.apply([], [styles.base, @props.style, dstyle.base])}>
      <div style={styles.title_wrap}>
        <div style={[styles.kind_string, @genKindStringStyle(@props.current.kindString), dstyle.kind_string]}>{@props.current.kindString}</div>
        <div style={[styles.title, dstyle.title]}>{@props.current.name}</div>
      </div>
      {
        unless @props.collapsed
          <div style={styles.from}>{"#{@props.current.kindString} in #{@props.from.name}"}</div>
      }
    </div>

styles =
  base:
    marginBottom: 40

  title_wrap:
    overflow: 'hidden'

  kind_string:
    fontSize: 18
    borderStyle: 'solid'
    borderWidth: 1
    paddingTop: 6
    paddingBottom: 6
    paddingLeft: 12
    paddingRight: 12
    marginTop: 3
    float: 'left'

  title:
    fontSize: 35
    paddingLeft: 12
    paddingRight: 12
    marginLeft: 10
    color: colors.general.r.emphasis
    float: 'left'
    fontWeight: 'bold'

  from:
    marginTop: 10
    fontSize: 15
    color: colors.general.r.light

DocTitleComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocTitleComponent
