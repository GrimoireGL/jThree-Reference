React = require 'react'
Radium = require 'radium'

$ = React.createElement

class OverviewSidebarItemComponent extends React.Component

  constructor: (props) ->
    super props

  render: ->
    $ 'div', style: styles['level' + @props.level],
      @props.children

styles =

  base:
    fontSize: 14
    padding: '10px 20px'
    marginRight: 20
    borderBottom: '1px solid #eee'

  level1:
    fontSize: 18
    padding: '10px 20px'
    marginRight: 20
    borderBottom: '1px solid #eee'

  level2:
    fontSize: 14
    padding: '10px 20px'
    marginRight: 20
    borderBottom: '1px solid #eee'

  level3:
    fontSize: 12
    padding: '10px 20px'
    marginRight: 20
    borderBottom: '1px solid #eee'


OverviewSidebarItemComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewSidebarItemComponent
