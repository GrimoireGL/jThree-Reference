React = require 'react'
Radium = require 'radium'
Route = require './route-component'
Link = require './link-component'
IndexComponent = require './index-component'
ErrorComponent = require './error-component'
ClassDocComponent = require './classdoc-component'
HeaderComponent = require './header-component'

class AppComponent extends React.Component
  constructor: (props) ->
    super props

  handleEvent: (e) ->
    if e.type == 'resize'
      @updateMainHeight()

  updateMainHeight: ->
    # console.log 'main height'
    minMainHeight = 1000
    mainHeight = if document.documentElement.clientHeight - 80 >= minMainHeight then document.documentElement.clientHeight - 80 else minMainHeight
    @setState
      mainHeight: mainHeight

  componentWillMount: ->
    @setState
      mainHeight: 0

  componentDidMount: ->
    @updateMainHeight()
    window.addEventListener 'resize', @

  componentWillUnmount: ->
    window.removeEventListener 'resize', @

  render: ->
    dstyle =
      main:
        height: @state.mainHeight
    <div style={styles.base}>
      <Route style={styles.header}>
        <HeaderComponent notroute='index' />
      </Route>
      <Route>
        <IndexComponent route='index' />
        <ClassDocComponent route='class' style={[styles.main, dstyle.main]} />
        <ErrorComponent route='error' style={[styles.main, dstyle.main]} />
      </Route>
    </div>

styles =
  base:{
    minWidth: 1000
  }

  header:
    position: 'fixed'
    zIndex: 100
    height: 80
    width: '100%'
    top: 0

  main:
    marginTop: 80

AppComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium AppComponent
