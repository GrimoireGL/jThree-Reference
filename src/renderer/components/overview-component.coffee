global.React = require 'react' # to use md2react
Radium = require 'radium'
md2react = require 'md2react'

class OverviewComponent extends React.Component
  
  constructor: (props) ->
    super props
  @contextTypes:
    ctx: React.PropTypes.any

  componentWillMount: ->
    @setState 
      markdown: @context.ctx.overviewStore.get().markdown

  render: ->
    $ = React.createElement
    markdown = @state.markdown
    $reactMd = md2react markdown

    $ 'div', className: 'markdown-content',
      $reactMd


module.exports = Radium OverviewComponent
