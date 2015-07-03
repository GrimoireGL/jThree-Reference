React = require 'react'
Radium = require 'radium'
CharIconComponent = require './char-icon-component'

class ListFolderComponent extends React.Component
  constructor: (props) ->
    super props
    @state =
      folded: @props.folded ? true

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
                  React.cloneElement child,
                    prepend: <CharIconComponent icomoon={if @state.folded then 'plus' else 'minus'} style={styles.toggle} />
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
  toggle:
    cursor: 'pointer'
    color: '#fff'
    backgroundColor: '#666'
    borderColor: '#666'
  expanded:
    display: 'block'

ListFolderComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ListFolderComponent
