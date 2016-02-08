React = require 'react'
Radium = require 'radium'
marked = require 'marked'

Route = require './route-component'

class OverviewMarkupComponent extends React.Component

  constructor: (props) ->
    super props
    @loadingQueue = []

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
    <div className={'markdown-component'} style={@props.style}>
      {
        console.log "markdowns:", @state.markup
        path = @props.argu.fragment_arr.filter((s, i)-> i >= 1).join('/')
        if @state.markup[path]
          splice_index = null
          for q, i in @loadingQueue
            if q == path
              splice_index = i
              break
          @loadingQueue.splice splice_index, 1 if splice_index?
          <div style={styles.container} dangerouslySetInnerHTML={__html: @state.markup[path]}></div>
        else
          if window?
            if !@loadingQueue.some((p) -> p == path)
              @loadingQueue.push path
              # console.log "path:", path
              @context.ctx.overviewAction.updateOverview "#{path}"
          <span>loading...</span>
      }
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
