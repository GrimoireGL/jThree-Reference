React = require 'react'
Radium = require 'radium'

$ = React.createElement

class OverviewSidebarItemComponent extends React.Component
  
  constructor: (props) ->
    super props

  render: ->
    console.log @props
    $ 'div', style: styles.base,
      @props.children

styles =

  base:
    fontSize: 14
    padding: '10px 20px'
    marginRight: 20
    borderBottom: '1px solid #eee'


OverviewSidebarItemComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewSidebarItemComponent
