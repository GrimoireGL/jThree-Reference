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
          elm.push <span style={styles.emphasis}>{c.signatures[0].name}</span>
          elm.push <span>(</span>
          c.signatures[0].parameters?.forEach (prm, i) ->
            elm.push <span style={styles.emphasis}>{prm.name}</span>
            if prm.defaultValue? || prm.flags.isOptional == true
              elm.push <span>{'?'}</span>
            elm.push <span>: </span>
            elm.push <span style={[styles.emphasis, styles.oblique]}>{prm.type.name}</span>
            if prm.type.typeArguments?
              elm.push <span>{'<'}</span>
              prm.type.typeArguments.forEach (targ, i) ->
                elm.push <span style={[styles.emphasis, styles.oblique]}>{targ.name}</span>
                if i != prm.type.typeArguments.length - 1
                  elm.push <span>, </span>
              elm.push <span>{'>'}</span>
            if prm.type.isArray
              elm.push <span>[]</span>
            if i != c.signatures[0].parameters.length - 1
              elm.push <span>, </span>
          elm.push <span>)</span>
          elm.push <span>: </span>
          elm.push <span style={[styles.emphasis, styles.oblique]}>{c.signatures[0].type.name}</span>
        else if c.type?
          elm.push <span style={styles.emphasis}>{c.name}</span>
          elm.push <span>: </span>
          elm.push <span style={[styles.emphasis, styles.oblique]}>{c.type.name}</span>
          if c.type.typeArguments?
            elm.push <span>{'<'}</span>
            c.type.typeArguments.forEach (targ, i) ->
              elm.push <span style={[styles.emphasis, styles.oblique]}>{targ.name}</span>
              if i != c.type.typeArguments.length - 1
                elm.push <span>, </span>
            elm.push <span>{'>'}</span>
          if c.type.isArray
              elm.push <span>[]</span>
        else if c.getSignature? || c.setSignature?
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
                <span style={styles.emphasis}>{c.name}</span>
                <span>(): </span>
                <span style={[styles.emphasis, styles.oblique]}>{c.getSignature[0].type.name}</span>
                {
                  if c.getSignature[0].type.isArray
                    <span>[]</span>
                }
              </div>
          if c.setSignature?
            elm.push do ->
              <div style={dstyle.set_signature}>
                <span>set </span>
                <span style={styles.emphasis}>{c.name}</span>
                <span>(</span>
                {
                  prm_elm = []
                  c.setSignature[0].parameters.forEach (prm, i) ->
                    prm_elm.push <span>{prm.name}</span>
                    prm_elm.push <span>: </span>
                    prm_elm.push <span style={[styles.emphasis, styles.oblique]}>{prm.type.name}</span>
                    if i != c.setSignature[0].parameters.length - 1
                      prm_elm.push <span>, </span>
                  prm_elm
                }
                <span>): </span>
                <span style={[styles.emphasis, styles.oblique]}>{c.getSignature[0].type.name}</span>
                {
                  if c.getSignature[0].type.isArray
                    <span>[]</span>
                }
              </div>
        else if c.name
          elm.push <span style={styles.emphasis}>{c.name}</span>
          elm.push <span>:</span>
        elm
      }
    </div>

styles =
  base:
    backgroundColor: '#333'
    color: '#999'
    paddingTop: 14
    paddingBottom: 13
    paddingLeft: 50
    paddingRight: 50
    marginRight: -50
    marginLeft: -50

  emphasis:
    color: '#eee'

  oblique:
    fontStyle: 'italic'

  code:
    fontFamily: 'Menlo, Monaco, Consolas, "Courier New", monospace'
    fontSize: 13

DocSignaturesComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocSignaturesComponent
