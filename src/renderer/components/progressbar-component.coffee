React = require 'react'
Radium = require 'radium'
Route = require './route-component'
Link = require './link-component'
colors = require './colors/color-definition'

class ProgressbarComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    dstyle =
      width: "#{@props.percentage}%"
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <div style={styles.container}>
        <div style={styles.titleWrapper}>
          <div style={styles.title}>{@props.children}</div>
          <div style={styles.percentage}>{"#{@props.percentage.toFixed(1)}%"}</div>
        </div>
        <div style={styles.barWrapper}>
          <div style={[styles.barProgress, dstyle]}></div>
        </div>
      </div>
    </div>

styles =
  base: {}
  container: {}
  titleWrapper:
    height: 60
    position: 'relative'
  title:
    position: 'absolute'
    left: 0
    bottom: 8
    fontSize: 18
  percentage:
    position: 'absolute'
    right: 0
    bottom: 0
    fontSize: 30
  barWrapper:
    height: 5
    backgroundColor: 'rgba(0, 0, 0, 0.2)'
  barProgress:
    height: 5
    backgroundColor: colors.main.n.moderate

ProgressbarComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ProgressbarComponent
