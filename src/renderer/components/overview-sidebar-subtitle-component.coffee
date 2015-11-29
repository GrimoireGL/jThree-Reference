React = require 'react'
Radium = require 'radium'
Link = require './link-component'

$ = React.createElement

class OverviewSidebarSubtitleComponent extends React.Component
  
  constructor: (props) ->
    super props

  render: ->
    $ 'div', style: [].concat.apply([], [styles.base, @props.style]),
      $ Link, style: {}, href: "",
        @props.children


styles = 

  base: 
    paddingLeft: 10


OverviewSidebarSubtitleComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewSidebarSubtitleComponent
