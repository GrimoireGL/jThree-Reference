React = require 'react'
Radium = require 'radium'
Link = require './link-component'

class OverviewSidebarTitleComponent extends React.Component

  constructor: (props) ->
    super props

  titleToUrl: (title) ->
    title
      .replace /^\s+/, ""
      .replace /\s+$/, ""
      .replace /\s/, "-"

  render: ->
    <div style={[].concat([], styles.base, @props.style)}>
      {
        if @props.level == 1
          <Link style={styles["title1"]} href={"/overview/#{@titleToUrl(@props.children)}"}>
            {@props.children}
          </Link>
        else
          <Link style={styles["title#{@props.level}"]} href={"/overview/#{@titleToUrl(@props.root)}##{@titleToUrl(@props.children)}"}>
            {@props.children}
          </Link>
      }
    </div>

styles =
  title1: # title
    fontSize: 24
  title2: # subtite
    fontSize: 20
  title3: # subsubtitle
    fontSize: 16


OverviewSidebarTitleComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewSidebarTitleComponent
