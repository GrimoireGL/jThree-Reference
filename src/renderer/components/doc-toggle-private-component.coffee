React = require 'react'
Radium = require 'radium'
Link = require './link-component'
DocTitleComponent = require './doc-title-component'
DocFlagtagsComponent = require './doc-flagtags-component'
colors = require './colors/color-definition'
Cookie = require 'js-cookie'
###
@props.current [required]
@props.from [required]
@props.collapsed
@props.style
###
class DocTogglePrivateComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    targetStyle = if @props.visibility then styles.visibleToggleBtn else styles.invisibleToggleBtn;
    <div style={targetStyle} onClick={@handleClick.bind(this)}>
      Private
    </div>


  handleClick:->
    Cookie.set('privateVisibility',(!@props.visibility).toString())
    @props.onChanged()


styles =
  invisibleToggleBtn:
    width:80
    marginLeft:"auto"
    borderColor:colors.main.n.default
    borderWidth:1
    borderStyle:"solid"
    textAlign:"center"
    borderRadius:15
    color:colors.main.n.default
    cursor:"pointer"
  visibleToggleBtn:
    width:80
    marginLeft:"auto"
    borderColor:colors.main.n.default
    borderWidth:1
    borderStyle:"solid"
    textAlign:"center"
    borderRadius:15
    color:colors.general.n.light
    cursor:"pointer"
    backgroundColor:colors.main.n.default

DocTogglePrivateComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocTogglePrivateComponent
