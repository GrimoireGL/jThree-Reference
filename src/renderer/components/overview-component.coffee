global.React = require 'react' # to use md2react
Radium = require 'radium'
md2react = require 'md2react'
hl = require("highlight").Highlight;

class OverviewComponent extends React.Component
  
  constructor: (props) ->
    super props

  componentWillMount: ->
    @setState 
      markdown: @context.ctx.overviewStore.get().markdown

  render: ->
    $ = React.createElement
    markdown = @state.markdown
    $reactMd = md2react markdown

    $ 'div', className: 'markdown-content', style: @props.style,
      $ 'div', style: styles.container,
        $reactMd

styles =
  container:
    flexGrow: '1'
    WebkitFlexGrow: '1'
    display: 'flex'
    display: '-webkit-flex'
    flexDirection: 'column'
    WebkitFlexDirection: 'column'
    flexWrap: 'nowrap'
    WebkitFlexWrap: 'nowrap'
    marginLeft: 120
    marginRight: 120


OverviewComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewComponent
