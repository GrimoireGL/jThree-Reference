React = require 'react'
Radium = require 'radium'
Route = require './route-component'
Link = require './link-component'
DocTitleComponent = require './doc-title-component'

class DocContainerComponents extends React.Component
  constructor: (props) ->
    super props

  render: ->
    # console.log "render DocContainer", (+new Date()).toString()[-4..-1]
    file_id = @props.argu.route_arr[2]?.toString()
    factor_id = @props.argu.route_arr[3]?.toString()
    <div style={styles.base}>
      {
        if file_id? && factor_id?
          current = @props.doc_data[file_id]?[factor_id]
          if current?
            <div>
              <DocTitleComponent current={current} from={@props.doc_data[file_id].from} />
              <div>
                {
                  if current.groups?
                    for group in current.groups
                      <div key={group.kind}>
                        <h2>{group.title}</h2>
                        <div>
                          {
                            for id in group.children
                              child = null
                              for c in current.children
                                if c.id == id
                                  child = c
                              if child?
                                <div key={child.id}>
                                  <h3>{child.name}</h3>
                                </div>
                              else
                                null
                          }
                        </div>
                      </div>
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
    paddingLeft: 40
    paddingRight: 40
    paddingTop: 20
    paddingBottom: 20

DocContainerComponents.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocContainerComponents
