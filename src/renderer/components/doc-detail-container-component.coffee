React = require 'react'
Radium = require 'radium'

class DocDetailContainerComponent extends React.Component
  constructor: (props) ->
    super props

  close: ->
    if @props.argu.route_arr[1]?.toString() == 'local'
      @context.ctx.routeAction.navigate(document.location.pathname.match(/^(.+)\/[^\/]+$/)[1])

  render: ->
    file_id = @props.argu.route_arr[2]?.toString()
    factor_id = @props.argu.route_arr[3]?.toString()
    local_factor_id = @props.argu.route_arr[4]?.toString()
    collapsed = false
    if @props.argu.route_arr[1]?.toString() == 'local'
      collapsed = true
    if collapsed
      <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
        <div onClick={@close.bind(@)}>close</div>
        {
          if file_id? && factor_id?
            current = @props.doc_data[file_id]?[factor_id]
            if current?
              current_local = null
              for c in current.children
                if c.id?.toString() == local_factor_id
                  current_local = c
              if current_local?
                <h1>{current_local.name}</h1>
        }
      </div>
    else
      null

styles =
  base:
    boxShadow: '-3px 0 4px 0 rgba(0, 0, 0, 0.2)'
    backgroundColor: '#fff'

DocDetailContainerComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocDetailContainerComponent
