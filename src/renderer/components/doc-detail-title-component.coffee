React = require 'react'
Radium = require 'radium'
DocDetailSignaturesComponent = require './doc-detail-signatures-component'
DocTitleComponent = require './doc-title-component'
DocFlagtagsComponent = require './doc-flagtags-component'
colors = require './colors/color-definition'

###
@props.current [required] local current which is child of current factor
@props.style
###
class DocDetailTitleComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    dstyle =
      kind_string:
        borderRadius: 7

    <DocTitleComponent title={".#{@props.current.name}"} kindString={@props.current.kindString} dstyle={dstyle} style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        if @props.current.inheritedFrom?
          <div style={styles.from}>
            <span>{"Inherited from #{@props.current.inheritedFrom.name.replace(/__constructor/, 'constructor')}"}</span>
          </div>
      }
      {
        if @props.current.overwrites?
          <div style={styles.from}>
            <span>{"Overwrites #{@props.current.overwrites.name.replace(/__constructor/, 'constructor')}"}</span>
          </div>
      }
      <DocFlagtagsComponent flags={@props.current.flags} style={styles.tags} />
      <DocDetailSignaturesComponent style={styles.signatures} current={@props.current} />
    </DocTitleComponent>

styles =
  base: {}

  from:
    marginBottom: 11

  tags:
    marginBottom: 11

  signatures:
    marginTop: 23

DocDetailTitleComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocDetailTitleComponent
