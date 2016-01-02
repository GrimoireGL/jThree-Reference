React = require 'react'
Radium = require 'radium'
OverviewMarkupComponent = require './overview-markup-component'
OverviewSidebarComponent = require './overview-sidebar-component'
Route = require './route-component'
Promise = require 'superagent'

class OverviewComponent extends React.Component

  constructor: (props) ->
    super props

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <div style={styles.sidebar}>
        <OverviewSidebarComponent />
      </div>
      <div style={styles.contents}>
        <Route>
          <OverviewMarkupComponent />
        </Route>
      </div>
    </div>

styles =

  base:
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
    flexDirection: 'column'
    WebkitFlexDirection: 'column'
    flexWrap: 'nowrap'
    WebkitFlexWrap: 'nowrap'
    marginLeft: 360


OverviewComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewComponent
