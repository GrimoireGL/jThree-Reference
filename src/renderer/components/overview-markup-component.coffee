React = require 'react'
Radium = require 'radium'
marked = require 'marked'

$ = React.createElement

class OverviewMarkupComponent extends React.Component

  constructor: (props) ->
    super props

  shouldComponentUpdate: (nextProps, nextState) ->
    nextProps.markup != @props.marked

  getMd: ->
    @props.markup

  render: ->
    $ 'div', className: 'markdown-component', style: @props.style,
      $ 'div', style: styles.container, dangerouslySetInnerHTML: __html: @props.markup

styles =
  container: {}
#     flexGrow: '1'
#     WebkitFlexGrow: '1'
#     display: 'flex'
#     display: '-webkit-flex'
#     flexDirection: 'column'
#     WebkitFlexDirection: 'column'
#     flexWrap: 'nowrap'
#     WebkitFlexWrap: 'nowrap'
#     marginLeft: 120
#     marginRight: 120


OverviewMarkupComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewMarkupComponent
