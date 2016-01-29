React = require 'react'
Radium = require 'radium'
DocDetailParametersTableComponent = require './doc-detail-parameters-table-component'
DocSignaturesTypeComponent = require './signatures/doc-signatures-type-component'
DocItemComponent = require './doc-item-component'
colors = require './colors/color-definition'

###
@props.current [required] current factor
@props.style
###
class DocTypeparameterComponent extends React.Component
  constructor: (props) ->
    super props

  constructTreeFromArray = (arr) ->
    <ul style={styles.ul}>
      {
        a = arr[0]
        a = if a instanceof Array then a else [a]
        for value, i in a
          <li style={styles.li}>
            <span>{value}</span>
            {
              if i == a.length - 1
                constructTreeFromArray arr[1..-1] if arr.length != 1
            }
          </li>
      }
    </ul>

  render: ->
    <DocItemComponent title='Hierarchy' style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        parents = @props.current.extendedTypes?.map (o) ->
          <span style={[styles.type, styles.not_current]}>
            <DocSignaturesTypeComponent type={o} emphasisStyle={styles.emphasis} />
          </span>
        children = @props.current.extendedBy?.map (o) ->
          <span style={[styles.type, styles.not_current]}>
            <DocSignaturesTypeComponent type={o} emphasisStyle={styles.emphasis} />
          </span>
        current = <span style={styles.current}>{@props.current.name}</span>
        tree_arr = []
        [parents, current, children].forEach (v) ->
          tree_arr.push v if v?
        <div>
          {
            constructTreeFromArray tree_arr
          }
        </div>
      }
    </DocItemComponent>

styles =
  base: {}

  li:
    marginTop: 4
    listStyle: 'square'

  ul:
    marginTop: 4
    paddingLeft: 20

  current:
    fontWeight: 'bold'
    color: colors.general.r.emphasis

  not_current: {}

  type:
    color: colors.general.r.light

  emphasis:
    color: colors.general.r.default

DocTypeparameterComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocTypeparameterComponent
