React = require 'react'
Radium = require 'radium'
Route = require './route-component'
Link = require './link-component'
DocTitleComponent = require './doc-title-component'
DocDescriptionComponent = require './doc-description-component'
DocItemComponent = require './doc-item-component'

class DocContainerComponents extends React.Component
  constructor: (props) ->
    super props

  close: ->
    if @props.argu.route_arr[1]?.toString() == 'local'
      @context.ctx.routeAction.navigate(document.location.pathname.match(/^(.+)\/[^\/]+$/)[1])

  render: ->
    # console.log "render DocContainer", (+new Date()).toString()[-4..-1]
    file_id = @props.argu.route_arr[2]?.toString()
    factor_id = @props.argu.route_arr[3]?.toString()
    collapsed = false
    if @props.argu.route_arr[1]?.toString() == 'local'
      collapsed = true
    dstyle = {}
    if collapsed
      dstyle =
        base:
          boxSizing: 'border-box'
          width: 120
          paddingLeft: 18
          paddingRight: 0
          overflow: 'hidden'
          transitionProperty: 'all'
          transitionDuration: '0.1s'
          # transitionDelay: '0.5s'
          transitionTimingFunction: 'ease-in-out'

          ':hover':
            width: 210
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style, dstyle.base])} onClick={@close.bind(@)}>
      {
        if file_id? && factor_id?
          current = @props.doc_data[file_id]?[factor_id]
          if current?
            <div>
              <DocTitleComponent current={current} from={@props.doc_data[file_id].from} collapsed={collapsed} />
              {
                unless collapsed
                  <DocDescriptionComponent current={current} />

              }
              <div>
                {
                  if current.groups?
                    for group in current.groups
                      <DocItemComponent key={group.kind} group={group} current={current} collapsed={collapsed} />
                  else
                    null
                }
              </div>
            </div>
          else
            if window?
              @context.ctx.docAction.updateDoc file_id, factor_id
            else
              throw new Error 'doc_data must be initialized by initialStates'
              # TODO: show activity indicator while loading docs
            <span>Loading...</span>
        else
          null
      }
    </div>

styles =
  base:
    paddingLeft: 50
    paddingRight: 50
    paddingTop: 30
    paddingBottom: 30

DocContainerComponents.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocContainerComponents
