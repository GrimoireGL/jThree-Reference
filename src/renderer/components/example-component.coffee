React = require 'react'
Radium = require 'radium'
ExampleMarkupComponent = require './example-markup-component'
ExampleSidebarComponent = require './example-sidebar-component'
Route = require './route-component'
Promise = require 'superagent'

class ExampleComponent extends React.Component

  constructor: (props) ->
    super props

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <div style={styles.sidebar}>
        <ExampleSidebarComponent />
      </div>
      <div style={styles.contents}>
        <Route>
          <ExampleMarkupComponent />
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


ExampleComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ExampleComponent
