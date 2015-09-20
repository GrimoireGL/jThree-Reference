React = require 'react'
Radium = require 'radium'

$ = React.createElement

class OverviewSidebarTitleComponent extends React.Component
  
  constructor: (props) ->
    super props

  render: ->
    $ 'div', style: [].concat([], styles.base, @props.style), 
      @props.children

styles = 
  base: {}
OverviewSidebarTitleComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewSidebarTitleComponent
