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
    @context.ctx.overviewAction.updateOverview(1)
    @setState
      # markdown: @context.ctx.overviewStore.get().markdown
      structure: @context.ctx.overviewStore.get().structure

  render: ->
    structure = @state.structure
    $ 'div', style: [].concat.apply([], [styles.sidebar, @props.style]),
      $ OverviewSidebarItemComponent, {},
        structure.map (data) ->
          $ OverviewSidebarTitleComponent, level: data.level,
            data.title

styles =
  sidebar: {}


OverviewSidebarComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewSidebarComponent
