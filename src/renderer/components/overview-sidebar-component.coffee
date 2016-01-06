React = require 'react'
Radium = require 'radium'
OverviewSidebarItemComponent = require './overview-sidebar-item-component'
OverviewSidebarTitleComponent = require './overview-sidebar-title-component'
Route = require './route-component'

class OverviewSidebarComponent extends React.Component

  constructor: (props) ->
    super props

  _onChange: ->
    @setState @store.get()

  componentWillMount: ->
    @store = @context.ctx.overviewStore
    @setState @store.get()

  componentDidMount: ->
    @store.onChange @_onChange.bind(@)

  componentWillUnmount: ->
    @store.removeChangeListener(@_onChange.bind(@))

  render: ->
    structure = @state.structure
    <div style={[].concat.apply([], [styles.sidebar, @props.style])}>
      <OverviewSidebarItemComponent>
        {
          structure.map (data) ->
            <OverviewSidebarTitleComponent level={data.level} url={data.url}>
              {data.title}
            </OverviewSidebarTitleComponent>
        }
      </OverviewSidebarItemComponent>
    </div>

styles =
  sidebar: {}


OverviewSidebarComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewSidebarComponent
