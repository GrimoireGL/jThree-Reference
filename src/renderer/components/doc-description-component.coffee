React = require 'react'
Radium = require 'radium'
DocItemComponent = require './doc-item-component'
colors = require './colors/color-definition'

###
@props.text (array|string) description text
###
class DocDescriptionComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    alt_text = 'no description'
    texts = if @props.text instanceof Array
      @props.text
    else
      @props.text?.split('\n')
    texts = if texts.some((t) -> t?) then texts else [alt_text]
    <DocItemComponent title='Description' style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <div style={styles.content}>
        {
          texts.map (t) -> if t? then <p>{t}</p>
        }
      </div>
    </DocItemComponent>

styles =
  base: {}

  content:
    color: colors.general.r.default

DocDescriptionComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocDescriptionComponent
