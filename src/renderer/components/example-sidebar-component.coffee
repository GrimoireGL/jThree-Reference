React = require 'react'
Radium = require 'radium'
ExampleSidebarItemComponent = require './example-sidebar-item-component'
ExampleSidebarTitleComponent = require './example-sidebar-title-component'
Route = require './route-component'

class ExampleSidebarComponent extends React.Component

  constructor: (props) ->
    super props

  _onChange: ->
    @setState @store.get()

  componentWillMount: ->
    @store = @context.ctx.exampleStore
    @setState @store.get()

  componentDidMount: ->
    @store.onChange @_onChange.bind(@)

  componentWillUnmount: ->
    @store.removeChangeListener(@_onChange.bind(@))

  render: ->
    structure = @state.structure
    <div style={[].concat.apply([], [styles.sidebar, @props.style])}>
      <ExampleSidebarItemComponent>
        {
          structure.map (data) ->
            <ExampleSidebarTitleComponent level={data.level} url={data.url}>
              {data.title}
            </ExampleSidebarTitleComponent>
        }
      </ExampleSidebarItemComponent>
    </div>

styles =
  sidebar: {}


ExampleSidebarComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ExampleSidebarComponent
