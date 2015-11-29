React = require 'react'
Radium = require 'radium'
Link = require './link-component'

$ = React.createElement

class OverviewSidebarTitleComponent extends React.Component
  
  constructor: (props) ->
    super props

  render: ->
    $ 'div', style: [].concat([], styles.base, @props.style), 
      $ Link, style: styles["title"+@props.level], href: "",
        @props.children

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
