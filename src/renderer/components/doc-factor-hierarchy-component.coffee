React = require 'react'
Radium = require 'radium'
DocDetailParametersTableComponent = require './doc-detail-parameters-table-component'
DocItemComponent = require './doc-item-component'

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
        parents = @props.current.extendedTypes?.map (o) -> <span style={styles.not_current}>{o.name}</span>
        children = @props.current.extendedBy?.map (o) -> <span style={styles.not_current}>{o.name}</span>
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

  not_current: {}

DocTypeparameterComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocTypeparameterComponent
