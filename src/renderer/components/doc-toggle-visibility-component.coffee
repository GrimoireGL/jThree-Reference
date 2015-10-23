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

  render: ->
    targetStyle = if @props.visibility then styles.visibleToggleBtn else styles.invisibleToggleBtn;
    <div style={[styles.toggleBtn,targetStyle]} onClick={@handleClick.bind(this)}>
      {@props.displayName}
    </div>


  handleClick:->
    @props.onChanged(!@props.visibility,@props.buttonKey)

styles =
  toggleBtn:
    width:80
    marginLeft:"auto"
    borderColor:colors.main.n.default
    borderWidth:1
    borderStyle:"solid"
    textAlign:"center"
    borderRadius:15
    cursor:"pointer"
    display:"inline"
    paddingTop:5
    paddingBottom:5
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
