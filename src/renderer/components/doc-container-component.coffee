React = require 'react'
Route = require './route-component'
Link = require './link-component'

class DocContainerComponents extends React.Component
  constructor: (props) ->
    super props

  render: ->
    id = @props.argu.route_arr[2]?.toString()
    <div>
      {
        if id?
          current = @props.doc_data[id]
          if current?
            <div>
              <h1>{current.name}</h1>
              <div>
                {
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
                                <div>
                                  {
                                    if child.groups?
                                      for group_ in child.groups
                                        <div key={group_.kind}>
                                          <h4>{group_.title}</h4>
                                          <div>
                                            {
                                              for id_ in group_.children
                                                child_ = null
                                                for c_ in child.children
                                                  if c_.id == id_
                                                    child_ = c_
                                                if child_?
                                                  <div key={child_.id}>
                                                    <p>{child_.name}</p>
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
                              null
                        }
                      </div>
                    </div>
                }
              </div>
            </div>
          else
            if window?
              @context.ctx.docAction.updateDoc id
            else
              throw new Error 'doc_data must be initialized by initialStates'
              # TODO: show activity indicator while loading docs
            <span>Loading...</span>
        else
          null
      }
    </div>

DocContainerComponents.contextTypes =
  ctx: React.PropTypes.any

module.exports = DocContainerComponents
