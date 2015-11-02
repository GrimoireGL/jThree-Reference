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
        # 1
        test() # ここ?
        # $ OverviewSidebarTitleComponent, {},
        #   "タイトル" + i
        # $ OverviewSidebarSubtitleComponent, {},
        #   "サブタイトル" + i2

  test = ->
    datas = [{
      title: "hello"
      level: 1
    }, {
      title: "hello"
      level: 2
    }, {
      title: "hello"
      level: 3
    }]
    datas.map (data) ->
      $ OverviewSidebarTitleComponent, level: data.level,
        data.title


styles =
  sidebar: {}


OverviewSidebarComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewSidebarComponent
