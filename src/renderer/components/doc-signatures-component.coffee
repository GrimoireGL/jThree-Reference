React = require 'react'
Radium = require 'radium'

class DocSignaturesComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    c = @props.current
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style, styles.code])}>
      {
        elm = []
        if c.signatures?
          elm.push <span>{c.signatures[0].name}</span>
          elm.push <span>(</span>
          c.signatures[0].parameters?.forEach (prm, i) ->
            elm.push <span>{prm.name}</span>
            elm.push <span>: </span>
            elm.push <span>{prm.type.name}</span>
            if prm.type.isArray
              elm.push <span>[]</span>
            if i != c.signatures[0].parameters.length - 1
              elm.push <span>, </span>
          elm.push <span>)</span>
          elm.push <span>: </span>
          elm.push <span>{c.signatures[0].type.name}</span>
        else if c.type?
          elm.push <span>{c.name}</span>
          elm.push <span>: </span>
          elm.push <span>{c.type.name}</span>
          if c.type.typeArguments?
            elm.push <span>{'<'}</span>
            elm.push <span>{c.type.typeArguments[0].name}</span>
            elm.push <span>{'>'}</span>
        else
          dstyle = {}
          if c.getSignature? && c.setSignature?
            dstyle =
              get_signature:
                paddingBottom: 11
                borderBottomWidth: 1
                borderBottomStyle: 'solid'
                borderBottomColor: '#555'
              set_signature:
                paddingTop: 10
          if c.getSignature?
            elm.push do ->
              <div style={dstyle.get_signature}>
                <span>get </span>
                <span>{c.name}</span>
                <span>(): </span>
                <span>{c.getSignature[0].type.name}</span>
                {
                  if c.getSignature[0].type.isArray
                    <span>[]</span>
                }
              </div>
          if c.setSignature?
            elm.push do ->
              <div style={dstyle.set_signature}>
                <span>set </span>
                <span>{c.name}</span>
                <span>(</span>
                {
                  prm_elm = []
                  c.setSignature[0].parameters.forEach (prm, i) ->
                    prm_elm.push <span>{prm.name}</span>
                    prm_elm.push <span>: </span>
                    prm_elm.push <span>{prm.type.name}</span>
                    if i != c.setSignature[0].parameters.length - 1
                      prm_elm.push <span>, </span>
                  prm_elm
                }
                <span>): </span>
                <span>{c.getSignature[0].type.name}</span>
                {
                  if c.getSignature[0].type.isArray
                    <span>[]</span>
                }
              </div>
        elm
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
