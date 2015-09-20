React = require 'react'
Radium = require 'radium'

$ = React.createElement

class OverviewSidebarSubtitleComponent extends React.Component
  
  constructor: (props) ->
    super props

  render: ->
    $ 'div', style: [].concat.apply([], [styles.base, @props.style]),
      @props.children


styles = 

  base: 
    paddingLeft: 10


OverviewSidebarSubtitleComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewSidebarSubtitleComponent
