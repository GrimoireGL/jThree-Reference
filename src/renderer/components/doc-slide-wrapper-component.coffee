React = require 'react'
Radium = require 'radium'
objectAssign = require 'object-assign'
clone = require 'lodash.clone'

###
@props.children[0] [require] to be left
@props.children[1] [require] to be right
@props.style
###
class DocSlideWrapperComponent extends React.Component
  constructor: (props) ->
    super props

  handleEvent: (e) ->
    if e.type == 'resize'
      @updateWrapperWidth()

  updateWrapperWidth: ->
    @setState
      wrapperWidth: React.findDOMNode(@refs.docWrapper).clientWidth - slide.from

  componentDidMount: ->
    @updateWrapperWidth()
    window.addEventListener 'resize', @

  componentWillUnmount: ->
    window.removeEventListener 'resize', @

  close: ->
    if @props.argu.route_arr[1]?.toString() == 'local'
      @context.ctx.routeAction.navigate(document.location.pathname.match(/^(.+)\/[^\/]+$/)[1])

  render: ->
    dstyle = {}
    collapsed = false
    if @props.argu.route_arr[1]?.toString() == 'local'
      collapsed = true
    if @state.wrapperWidth
      dstyle.wrapper =
          width: @state.wrapperWidth
    if collapsed
      dstyle.left =
        boxSizing: 'border-box'
        width: slide.from
        paddingLeft: 18
        paddingRight: 0
        overflow: 'hidden'
        whiteSpace: 'nowrap'
        transitionProperty: 'all'
        transitionDuration: '0.1s'
        # transitionDelay: '0.5s'
        transitionTimingFunction: 'ease-in-out'

        ':hover':
          width: slide.to
    props = {}
    for k, v of @props
      if k != 'children' && k != 'style'
        props[k] = clone v, true
    objectAssign props,
      collapsed: collapsed
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])} ref='docWrapper'>
      <div style={[styles.left, dstyle.left]} ref='docLeft' onClick={@close.bind(@)}>
        {
          React.Children.map @props.children, (c, i) ->
            React.cloneElement c, props if i == 0
        }
      </div>
      {
        if collapsed
          <div style={styles.right} ref='docRight'>
            <div style={styles.close} onClick={@close.bind(@)}>
              <span className='icon-close' style={styles.close_icon}></span>
            </div>
            <div style={[styles.wrapper, dstyle.wrapper]}>
              {
                React.Children.map @props.children, (c, i) ->
                  React.cloneElement c, props if i == 1
              }
            </div>
          </div>
      }
    </div>

slide =
  from:
    120
  to:
    210

styles =
  base:
    display: 'flex'
    flexDirection: 'row'
    flexWrap: 'nowrap'
    flexGrow: '1'

  left:
    paddingLeft: 50
    paddingRight: 50
    paddingTop: 30
    paddingBottom: 30
    boxSizing: 'border-box'

  right:
    flexGrow: '1'
    position: 'relative'
    overflow: 'hidden'
    boxShadow: '0 0 3px 0 rgba(0, 0, 0, 0.4)'
    backgroundColor: '#fff'

  close:
    position: 'absolute'
    top: 7
    left: 8
    cursor: 'pointer'

  close_icon:
    borderWidth: 0
    fontSize: 20
    color: '#ccc'
    transitionProperty: 'all'
    transitionDuration: '0.1s'
    transitionTimingFunction: 'ease-in-out'

    ':hover':
      color: '#111'

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
