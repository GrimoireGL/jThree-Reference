React = require 'react'
Radium = require 'radium'
DocDetailSignaturesComponent = require './doc-detail-signatures-component'
DocTitleComponent = require './doc-title-component'
colors = require './colors/color-definition'

###
@props.current [required]
@props.style
###
class DocDetailTitleComponent extends React.Component
  constructor: (props) ->
    super props

  genKindStringStyle: (kindString) ->
    color = colors.general.r.default

    switch kindString
      when 'Constructor'
        color = '#337BFF'
      when 'Property'
        color = '#598213'
      when 'Method'
        color = '#6E00FF'
      when 'Accessor'
        color = '#D04C35'
      when 'Enumeration member'
        color = '#B17509'
      else
        color = colors.general.r.default

    style =
      color: color
      borderColor: color

  render: ->
    dstyle =
      kind_string:
        borderRadius: 7

    <DocTitleComponent title={".#{@props.current.name}"} kindString={@props.current.kindString} dstyle={dstyle} style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <div>
        {
          if @props.current.inheritedFrom?
            <span style={styles.from}>{"Inherited from #{@props.current.inheritedFrom.name.replace(/__constructor/, 'constructor')}"}</span>
        }
        <DocDetailSignaturesComponent style={styles.signatures} current={@props.current} />
      </div>
    </DocTitleComponent>

styles =
  base: {}

  signatures:
    marginTop: 23

DocDetailTitleComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocDetailTitleComponent
