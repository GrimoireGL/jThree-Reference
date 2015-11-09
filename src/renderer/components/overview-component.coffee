React = require 'react'
Radium = require 'radium'
OverviewMarkdownComponent = require './overview-markdown-component'
OverviewSidebarComponent = require './overview-sidebar-component'
Route = require './route-component'

$ = React.createElement

class OverviewComponent extends React.Component

  constructor: (props) ->
    super props
    console.log @props.argu.route_arr

  render: ->
    $ 'div', style: Array.prototype.concat.apply([], [styles.base, @props.style]),
      $ 'div', style: styles.sidebar,
        $ Route, {},
          $ OverviewSidebarComponent
      $ 'div', style: styles.contents,
        $ Route, {},
          $ OverviewMarkdownComponent

styles =

  base:
    display: '-webkit-flex'
    display: 'flex'
    WebkitFlexDirection: 'row'
    flexDirection: 'row'
    width: '100%'

  sidebar:
    boxSizing: 'border-box'
    paddingLeft: 10
    paddingTop: 10
    width: 360
    borderRight: '1px solid #ccc'
    position: 'fixed'
    top: 80
    height: 'calc(100% - 80px)'
    overflowY: 'scroll'
    overflowX: 'hidden'
    zIndex: 10
    backgroundColor: '#fff'

  contents:
    boxSizing: 'border-box'
    width: 800
    padding: '0 80px 0 40px'
    flexGrow: '1'
    WebkitFlexGrow: '1'
    display: 'flex'
    display: '-webkit-flex'
    flexDirection: 'column'
    WebkitFlexDirection: 'column'
    flexWrap: 'nowrap'
    WebkitFlexWrap: 'nowrap'
    marginLeft: 360


OverviewComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewComponent
