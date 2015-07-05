React = require 'react'
Radium = require 'radium'

class DocTitleComponent extends React.Component
  constructor: (props) ->
    super props

  genKindStringStyle: (kindString) ->
    color = '#333333'

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
        color = '#333333'

    style =
      color: color
      borderColor: color

  render: ->
    <div style={styles.base}>
      <div style={styles.title_wrap}>
        <div style={[styles.kind_string, @genKindStringStyle(@props.current.kindString)]}>{@props.current.kindString}</div>
        <div style={styles.title}>{@props.current.name}</div>
      </div>
      <div style={styles.from}>{"#{@props.current.kindString} in #{@props.from.name}"}</div>
    </div>

styles =
  base: {}
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
    color: '#000'
    float: 'left'
    fontWeight: 'bold'
  from:
    marginTop: 10
    fontSize: 15
    color: '#aaa'

DocTitleComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocTitleComponent
