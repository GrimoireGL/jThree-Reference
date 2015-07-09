React = require 'react'
Radium = require 'radium'

class DocSignaturesComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    c = @props.current
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style, styles.code])}>
      {
        return_elm = []
        if c.signatures?
          return_elm.push <span>{c.signatures[0].name}</span>
          return_elm.push <span>(</span>
          c.signatures[0].parameters?.forEach (prm, i) ->
            return_elm.push <span>{prm.name}</span>
            return_elm.push <span>: </span>
            return_elm.push <span>{prm.type.name}</span>
            if prm.type.isArray
              return_elm.push <span>[]</span>
            if i != c.signatures[0].parameters.length - 1
              return_elm.push <span>, </span>
          return_elm.push <span>)</span>
          return_elm.push <span>: </span>
          return_elm.push <span>{c.signatures[0].type.name}</span>
        else if c.type?
          return_elm.push <span>{c.name}</span>
          return_elm.push <span>: </span>
          return_elm.push <span>{c.type.name}</span>
        return_elm
      }
    </div>

styles =
  base:
    backgroundColor: '#333'
    color: '#ddd'
    paddingTop: 14
    paddingBottom: 13
    paddingLeft: 50
    paddingRight: 50
    marginRight: -50
    marginLeft: -50

  code:
    fontFamily: 'Menlo, Monaco, Consolas, "Courier New", monospace'
    fontSize: 13

DocSignaturesComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocSignaturesComponent
