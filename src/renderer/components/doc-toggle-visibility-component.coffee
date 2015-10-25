React = require 'react'
Radium = require 'radium'
Link = require './link-component'
DocTitleComponent = require './doc-title-component'
DocFlagtagsComponent = require './doc-flagtags-component'
colors = require './colors/color-definition'
###
@props.current [required]
@props.from [required]
@props.collapsed
@props.style
###
class DocToggleVisibilityComponent extends React.Component
  constructor: (props) ->
    super props

  componentWillMount: ->
    @store = @context.ctx.toggleVisibilityStore
    @setState
      visibility: @store.get().visibility[@props.buttonKey]

  componentDidMount: ->
    @store.onChange =>
      @setState
        visibility: @store.get().visibility[@props.buttonKey]

  componentWillUnmount: ->
    @store.removeAllChangeListeners()

  render: ->
    targetStyle = if @state.visibility then styles.visibleToggleBtn else styles.invisibleToggleBtn
    <div style={[styles.toggleBtn, targetStyle]} onClick={@visibilityChanged.bind(@)}>
      {@props.displayName}
    </div>

  visibilityChanged:->
    @context.ctx.toggleVisibilityAction.toggleVisibility !@state.visibility, @props.buttonKey

styles =
  toggleBtn:
    marginLeft:"auto"
    borderColor:colors.main.n.default
    borderWidth:1
    borderStyle:"solid"
    textAlign:"center"
    borderRadius:15
    cursor:"pointer"
    display:"inline-block"
    boxSizing: 'border-box'
    paddingTop:5
    paddingBottom:4
    paddingLeft:20
    paddingRight:20
    marginLeft:10
    marginRight:10
  invisibleToggleBtn:
    color:colors.main.n.default
  visibleToggleBtn:
    color:colors.general.n.light
    backgroundColor:colors.main.n.default

DocToggleVisibilityComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocToggleVisibilityComponent
