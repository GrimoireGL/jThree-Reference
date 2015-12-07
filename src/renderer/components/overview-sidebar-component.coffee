React = require 'react'
Radium = require 'radium'
OverviewSidebarItemComponent = require './overview-sidebar-item-component'
OverviewSidebarTitleComponent = require './overview-sidebar-title-component'
OverviewSidebarSubtitleComponent = require './overview-sidebar-subtitle-component'


$ = React.createElement

class OverviewSidebarComponent extends React.Component

  constructor: (props) ->
    super props

  componentWillMount: ->
    @setState
      structure: @props.structure

  render: ->
    structure = @state.structure
    $ 'div', style: [].concat.apply([], [styles.sidebar, @props.style]),
      $ OverviewSidebarItemComponent, {},
        rootTitle = ""
        structure.map (data) ->
          if data.level == 1
            rootTitle = data.title
          $ OverviewSidebarTitleComponent, level: data.level, root: rootTitle,
            data.title

styles =
  sidebar: {}


OverviewSidebarComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewSidebarComponent
