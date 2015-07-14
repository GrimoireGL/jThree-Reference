React = require 'react'
Radium = require 'radium'
Route = require './route-component'
Link = require './link-component'
DocDescriptionComponent = require './doc-description-component'
DocFactorTitleComponent = require './doc-factor-title-component'
DocFactorItemComponent = require './doc-factor-item-component'
DocFactorHierarchyComponent = require './doc-factor-hierarchy-component'
DocTypeparameterComponent = require './doc-typeparameter-component'

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
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        if file_id? && factor_id?
          current = @props.doc_data[file_id]?[factor_id]
          if current?
            <div>
              <DocFactorTitleComponent current={current} from={@props.doc_data[file_id].from} collapsed={@props.collapsed} />
              {
                unless @props.collapsed
                  text = [current.comment?.shortText, current.comment?.text]
                  <DocDescriptionComponent text={text} />
              }
              {
                if current.typeParameter? && !@props.collapsed
                  <DocTypeparameterComponent current={current} />
              }
              {
                if !@props.collapsed && (current.extendedTypes? || current.extendedBy?)
                  <DocFactorHierarchyComponent current={current} />
              }
              {
                if current.groups?
                  for group in current.groups
                    <DocFactorItemComponent key={group.kind} group={group} current={current} collapsed={@props.collapsed} />
              }
            </div>
          else
            if window?
              @context.ctx.docAction.updateDoc file_id, factor_id
            else
              throw new Error 'doc_data must be initialized by initialStates'
              # TODO: show activity indicator while loading docs
            <span>Loading...</span>
      }
    </div>

styles =
  base: {}

DocContainerComponents.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocContainerComponents
