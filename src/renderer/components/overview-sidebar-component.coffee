React = require 'react'
Radium = require 'radium'
OverviewSidebarItemComponent = require './overview-sidebar-item-component'
OverviewSidebarTitleComponent = require './overview-sidebar-title-component'
OverviewSidebarSubtitleComponent = require './overview-sidebar-subtitle-component'


$ = React.createElement

class OverviewSidebarComponent extends React.Component
  
  constructor: (props) ->
    super props

  render: ->
    $ 'div', style: [].concat.apply([], [styles.sidebar, @props.style]), [0..15].map (v, i) ->
      $ OverviewSidebarItemComponent, {},
        $ OverviewSidebarTitleComponent, {}, 
          "タイトル" + i
        [0..3].map (v2, i2) ->
          $ OverviewSidebarSubtitleComponent, {},
            "サブタイトル" + i2

styles = 
  sidebar: {}


OverviewSidebarComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewSidebarComponent
