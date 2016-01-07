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
    @context.ctx.overviewAction.updateOverview "/#{@props.argu.fragment}"
    @setState @store.get()

  componentDidMount: ->
    @store.onChange @_onChange.bind(@)
    @setState @store.get()


  componentWillUnmount: ->
    @store.removeChangeListener(@_onChange.bind(@))
    @setState @store.get()

  # shouldComponentUpdate: (nextProps, nextState) ->
  #   true
  #   nextProps.markup != @props.marked


  getMd: ->
    @props.markup

  render: ->
    <div className={'markdown-component'} style={@props.style}>
      <Route>
        {
          console.log "markdowns:", @state.markup
          path = @props.argu.fragment_arr.filter((s, i)-> i >= 1).join("/")
          <div style={styles.container} dangerouslySetInnerHTML={__html: @state.markup[path]}></div>
        }
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
