React = require 'react'
Route = require './route-component'
Link = require './link-component'
IndexComponent = require './index-component'
ErrorComponent = require './error-component'
ClassDocComponent = require './classdoc-component'
HeaderComponent = require './header-component'

class AppComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <div>
      <Route>
        <HeaderComponent notroute='index' />
      </Route>
      <Route>
        <IndexComponent route='index' />
        <ClassDocComponent route='class' />
        <ErrorComponent route='error' />
      </Route>
    </div>

AppComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = AppComponent
