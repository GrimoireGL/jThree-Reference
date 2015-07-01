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
        return_elm = []
        React.Children.forEach @props.children, (child) =>
          if child.props.type == 'folder'
            return_elm.push React.cloneElement(child, {onClick: @toggle_fold.bind(@)})
          if child.props.type == 'children'
            return_elm.push React.cloneElement(child, {style: {display: (if @state.expanded then 'block' else 'none')}})
        return_elm
      }
    </div>

ListFolderComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = ListFolderComponent
