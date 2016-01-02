React = require 'react'
Radium = require 'radium'
marked = require 'marked'

Route = require './route-component'

class OverviewMarkupComponent extends React.Component

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

  # shouldComponentUpdate: (nextProps, nextState) ->
  #   nextProps.markup != @props.marked

  getMd: ->
    @props.markup

  render: ->
    <div className={'markdown-component'} style={@props.style}>
      <Route>
        <div style={styles.container} dangerouslySetInnerHTML={__html: @state.markup}></div>
      </Route>
    </div>

styles =
  container: {}
#     flexGrow: '1'
#     WebkitFlexGrow: '1'
#     display: 'flex'
#     display: '-webkit-flex'
#     flexDirection: 'column'
#     WebkitFlexDirection: 'column'
#     flexWrap: 'nowrap'
#     WebkitFlexWrap: 'nowrap'
#     marginLeft: 120
#     marginRight: 120


OverviewMarkupComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewMarkupComponent
