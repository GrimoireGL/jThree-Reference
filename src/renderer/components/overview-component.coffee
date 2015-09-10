React = require 'react' # to use md2react
Radium = require 'radium'
marked = require 'marked' 

$ = React.createElement

class OverviewComponent extends React.Component
  
  constructor: (props) ->
    super props

  componentWillMount: ->
    @setState 
      markdown: @context.ctx.overviewStore.get().markdown

  render: ->
    markdown = @state.markdown
    marked.setOptions highlight: (code) ->
      require('highlight.js').highlightAuto(code).value
    html = marked markdown
    $ 'div', className: 'markdown-content', style: @props.style,
      $ 'div', style: styles.container, dangerouslySetInnerHTML: __html: html

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
