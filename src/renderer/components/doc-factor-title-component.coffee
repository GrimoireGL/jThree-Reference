React = require 'react'
Radium = require 'radium'
Link = require './link-component'
DocTitleComponent = require './doc-title-component'
DocFlagtagsComponent = require './doc-flagtags-component'
DocToggleVisibilityComponent = require './doc-toggle-visibility-component'
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
      {
        unless @props.collapsed
          <div style={styles.from}>
            <span>
              <span>{"#{@props.current.kindString} in "}</span>
              <a style={styles.link} target='_new' href={"https://github.com/jThreeJS/jThree/tree/develop/jThree/src/#{@props.from.name.replace(/"/g, '')}.ts"}>{"#{@props.from.name.replace(/"/g, '').replace(/$/, '.ts')}"}</a>
            </span>
          </div>
      }
      {
        unless @props.collapsed
          <div style={styles.visibilityContainer}>
            <DocToggleVisibilityComponent onChanged={@props.onVisibilityChanged} visibility={@props.privateVisibility} displayName="Private" buttonKey="privateVisibility"/>
            <DocToggleVisibilityComponent onChanged={@props.onVisibilityChanged} visibility={@props.protectedVisibility} displayName="Protected" buttonKey="protectedVisibility"/>
          </div>
      }
      {
        unless @props.collapsed
          <DocFlagtagsComponent flags={@props.current.flags} style={styles.tags}/>
      }
    </DocTitleComponent>

styles =
  base: {}

  visibilityContainer:
    marginLeft:"auto"
    width:"300px"

  from:
    marginBottom: 4

  tags:
    marginTop: 11
    marginBottom: 11

  link:
    color: colors.general.r.light

DocFactorTitleComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocFactorTitleComponent
