React = require 'react'
Radium = require 'radium'

class DocSlideWrapperComponent extends React.Component
  constructor: (props) ->
    super props

  updateWrapperWidth: ->
    @setState
      wrapperWidth: React.findDOMNode(@refs.docDetailBase).clientWidth

  componentDidMount: ->
    @updateWrapperWidth()
    window.addEventListener 'resize', @updateWrapperWidth.bind(@)

  componentWillUnmount: ->
    window.removeEventListener 'resize', @updateWrapperWidth.bind(@)

  render: ->
    dstyle = {}
    if @state.wrapperWidth
      dstyle =
        wrapper:
          width: @state.wrapperWidth
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])} ref='docDetailBase'>
      <div style={[styles.wrapper, dstyle.wrapper]}>
        {@props.children}
      </div>
    </div>

styles =
  base:
    position: 'relative'
    overflow: 'hidden'

  wrapper:
    position: 'absolute'
    top: 0
    left: 0
    bottom: 0
    paddingLeft: 50
    paddingRight: 50
    paddingTop: 30
    paddingBottom: 30
    boxSizing: 'border-box'

DocSlideWrapperComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocSlideWrapperComponent
