React = require 'react'
Radium = require 'radium'
Link = require './link-component'
DocSignaturesComponent = require './doc-signatures-component'

class DocDetailTitleComponent extends React.Component
  constructor: (props) ->
    super props

  close: ->
    @context.ctx.routeAction.navigate(document.location.pathname.match(/^(.+)\/[^\/]+$/)[1])

  genKindStringStyle: (kindString) ->
    color = '#333333'

    switch kindString
      when 'Constructor'
        color = '#337BFF'
      when 'Property'
        color = '#598213'
      when 'Method'
        color = '#B17509'
      when 'Accessor'
        color = '#D04C35'
      when 'Function' # no assign
        color = '#6E00FF'
      else
        color = '#333333'

    style =
      color: color
      borderColor: color

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <div style={styles.title_wrap}>
        <div style={[styles.kind_string, @genKindStringStyle(@props.current.kindString)]}>{@props.current.kindString}</div>
        <div style={[styles.title]}>
          <span style={styles.title_from} onClick={@close.bind(@)}>{@props.from.name}</span>.<span>{@props.current.name}</span>
        </div>
      </div>
      <DocSignaturesComponent style={styles.signatures} current={@props.current} />
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
    borderRadius: 7

  title:
    fontSize: 35
    paddingLeft: 12
    paddingRight: 12
    marginLeft: 10
    color: '#000'
    float: 'left'
    fontWeight: 'bold'

  title_from:
    textDecoration: 'underline'
    cursor: 'pointer'

  signatures:
    marginTop: 23

DocDetailTitleComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocDetailTitleComponent
