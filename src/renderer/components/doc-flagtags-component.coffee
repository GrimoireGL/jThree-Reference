React = require 'react'
Radium = require 'radium'
colors = require './colors/color-definition'

###
@props.flags [required]
@props.style
###
class DocFlagtagsComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    dstyle = {}
    unless @props.flags?.isProtected || @props.flags?.isPrivate || @props.flags?.isStatic
      dstyle.base =
        marginBottom: 0
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style, dstyle.base])}>
      {
        elm = []
        if @props.flags?.isProtected
          elm.push <span style={styles.tag}><span style={styles.tag_icon} className='icon-unlock-alt'></span><span>Protected</span></span>
        if @props.flags?.isPrivate
          elm.push <span style={styles.tag}><span style={styles.tag_icon} className='icon-lock'></span><span>Private</span></span>
        if @props.flags?.isStatic
          elm.push <span style={styles.tag}><span style={styles.tag_icon} className='icon-thumb-tack'></span><span>Static</span></span>
        elm
      }
    </div>

styles =
  base:
    marginBottom: 11

  tag:
    display: 'inline-block'
    borderRadius: 13
    borderWidth: 1
    borderStyle: 'solid'
    borderColor: colors.inverse.n.moderate
    backgroundColor: colors.inverse.n.moderate
    color: colors.inverse.r.emphasis
    fontSize: 11
    paddingTop: 6
    paddingBottom: 3
    paddingLeft: 12
    paddingRight: 12
    marginRight: 16

  tag_icon:
    marginRight: 5

DocFlagtagsComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocFlagtagsComponent
