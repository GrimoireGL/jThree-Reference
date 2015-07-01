React = require 'react'

class ListFolderComponent extends React.Component
  constructor: (props) ->
    super props
    @state =
      expanded: false

  toggle_fold: ->
    @setState
      expanded: !@state.expanded

  render: ->
    <div>
      {
        do =>
          ret = []
          React.Children.forEach @props.children, (child) =>
            if child.props.type == 'folder'
              ret.push React.cloneElement(child, {onClick: @toggle_fold.bind(@)})
            if child.props.type == 'children'
              ret.push React.cloneElement(child, {style: {display: (if @state.expanded then 'block' else 'none')}})
          return ret
      }
    </div>

ListFolderComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = ListFolderComponent
