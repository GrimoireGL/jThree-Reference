React = require 'react'
Radium = require 'radium'

class ExampleSidebarItemComponent extends React.Component

  constructor: (props) ->
    super props

  render: ->
    <div style={styles['level' + @props.level]}>
      {
        @props.children
      }
    </div>

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


ExampleSidebarItemComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ExampleSidebarItemComponent
