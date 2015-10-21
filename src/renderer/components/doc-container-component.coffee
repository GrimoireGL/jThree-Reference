React = require 'react'
Radium = require 'radium'
Route = require './route-component'
Link = require './link-component'
DocDescriptionComponent = require './doc-description-component'
DocFactorTitleComponent = require './doc-factor-title-component'
DocFactorItemComponent = require './doc-factor-item-component'
DocFactorHierarchyComponent = require './doc-factor-hierarchy-component'
DocFactorImplementsComponent = require './doc-factor-implements-component'
DocTypeparameterComponent = require './doc-typeparameter-component'
DocSearchContainerComponent = require './doc-search-container-component'
Cookie = require 'js-cookie'


class DocContainerComponents extends React.Component
  constructor: (props) ->
    super props
    @loadingQueue = []
    @state = {privateVisibility:Cookie.get('privateVisibility')=="true"}

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
            splice_index = null
            for q, i in @loadingQueue
              if q.file_id == file_id && q.factor_id == factor_id
                splice_index = i
                break
            @loadingQueue.splice splice_index, 1 if splice_index?
            <div>
              <DocFactorTitleComponent current={current} from={@props.doc_data[file_id].from} collapsed={@props.collapsed} privateVisibility={@state.privateVisibility} onPrivateVisibilityChanged={@privateVisibilityChanged.bind(this)}/>
              {
                if !@props.collapsed
                  text = [current.comment?.shortText, current.comment?.text]
                  <DocDescriptionComponent text={text} />
              }
              {
                if !@props.collapsed && current.typeParameter?
                  <DocTypeparameterComponent current={current} />
              }
              {
                if !@props.collapsed && (current.extendedTypes? || current.extendedBy?)
                  <DocFactorHierarchyComponent current={current} />
              }
              {
                if !@props.collapsed && (current.implementedTypes? || current.implementedBy?)
                   <DocFactorImplementsComponent current={current} />
              }
              {
                if current.groups?
                  for group in current.groups
                    <DocFactorItemComponent key={group.kind} group={group} current={current} collapsed={@props.collapsed} privateVisibility={@state.privateVisibility}/>
              }
            </div>
          else
            if window?
              if !@loadingQueue.some((q) -> q.file_id == file_id && q.factor_id == factor_id)
                # console.log 'get'
                @loadingQueue.push
                  file_id: file_id
                  factor_id: factor_id
                @context.ctx.docAction.updateDoc file_id, factor_id
              else
                # console.log 'queue'
            else
              throw new Error 'doc_data must be initialized by initialStates'
              # TODO: show activity indicator while loading docs
            <span>Loading...</span>
        else
          <DocSearchContainerComponent />
      }
    </div>

  privateVisibilityChanged:(e)->
      @setState({privateVisibility:Cookie.get('privateVisibility')=="true"})

styles =
  base: {}



DocContainerComponents.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocContainerComponents
