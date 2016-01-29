React = require 'react'
Radium = require 'radium'
CharIconComponent = require './char-icon-component'
colors = require './colors/color-definition'

class ListFolderComponent extends React.Component
  constructor: (props) ->
    super props

  componentWillMount: ->
    @state =
      folded: @props.folded ? true

  componentWillReceiveProps: (nextProps) ->
    if @state.folded
      @setState
        folded: nextProps.folded

  shouldComponentUpdate: (nextProps, nextState) ->
    # console.log @props.folded, nextProps.folded, @state.folded, nextState.folded, @props.name
    return nextState.folded == false || @state.folded != nextState.folded

  toggle_fold: ->
    @setState
      folded: !@state.folded

  render: ->
    # console.log "render ListFolder #{@props.name}", (+new Date()).toString()[-4..-1]
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
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
  base: {}
  folded:
    display: 'none'
  toggle:
    cursor: 'pointer'
    color: colors.main.r.emphasis
    backgroundColor: colors.main.n.moderate
    borderColor: colors.main.n.moderate
  expanded:
    display: 'block'

ListFolderComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ListFolderComponent
