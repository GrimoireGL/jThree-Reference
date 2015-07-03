React = require 'react'
Radium = require 'radium'

class ListItemComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        return_elm = []
        prepend = []
        append = []
        if @props.prepend?
          prepend = if @props.prepend instanceof Array then @props.prepend else [@props.prepend]
          prepend = prepend.map (elm, i) ->
            React.cloneElement elm,
              key: 'p' + i
          return_elm = return_elm.concat prepend
        React.Children.forEach @props.children, (child, i) ->
          return_elm.push do ->
            React.cloneElement child,
              key: i
        if @props.append?
          append = if @props.append instanceof Array then @props.append else [@props.append]
          append = append.map (elm, i) ->
            React.cloneElement elm,
              key: 'a' + i
          return_elm = return_elm.concat append
        return_elm
      }
    </div>

styles =
  base:
    height: 30
    fontSize: 14
    WebkitUserSelect: 'none'
    color: '#333'

ListItemComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ListItemComponent
