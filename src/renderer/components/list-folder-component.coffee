React = require 'react'
Radium = require 'radium'

class ListFolderComponent extends React.Component
  constructor: (props) ->
    super props
    @state =
      folded: true

  toggle_fold: ->
    @setState
      folded: !@state.folded

  render: ->
    <div>
      {
        return_elm = []
        React.Children.forEach @props.children, (child) =>
          if child.props.type == 'folder'
            return_elm.push do =>
              <div key='folder' onClick={@toggle_fold.bind(@)} >
                {
                  child
                }
              </div>
          if child.props.type == 'children'
            return_elm.push do =>
              <div key='children' style={styles[if @state.folded then 'folded' else 'expanded']}>
                {
                  child
                }
              </div>
        return_elm
      }
    </div>

styles =
  folded:
    display: 'none'
  expanded:
    display: 'block'

ListFolderComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ListFolderComponent
