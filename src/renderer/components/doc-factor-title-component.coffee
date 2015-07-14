React = require 'react'
Radium = require 'radium'
Link = require './link-component'
DocTitleComponent = require './doc-title-component'
colors = require './colors/color-definition'

###
@props.current [required]
@props.from [required]
@props.collapsed
@props.style
###
class DocFactorTitleComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    dstyle = {}
    if @props.collapsed
      dstyle =
        base:
          marginBottom: 30

        kind_string:
          fontSize: 14
          paddingTop: 3
          paddingBottom: 1
          paddingLeft: 12
          paddingRight: 12
          marginLeft: 0
          marginRight: 12
          textAlign: 'center'
          float: 'none'
          display: 'inline-block'

        title:
          fontSize: 20
          paddingLeft: 0
          paddingRight: 0
          float: 'none'
          marginTop: 10
          marginLeft: 0

    <DocTitleComponent title={@props.current.name} kindString={@props.current.kindString} dstyle={dstyle} style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <div>
        {
          unless @props.collapsed
            <span>
              <span>{"#{@props.current.kindString} in "}</span>
              <a style={styles.link} target='_new' href={"https://github.com/jThreeJS/jThree/tree/develop/jThree/src/#{@props.from.name.replace(/"/g, '')}.ts"}>{"#{@props.from.name.replace(/"/g, '').replace(/$/, '.ts')}"}</a>
            </span>
        }
      </div>
    </DocTitleComponent>

styles =
  base: {}

  link:
    color: colors.general.r.light

DocFactorTitleComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocFactorTitleComponent
