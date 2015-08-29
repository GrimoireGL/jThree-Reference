global.React = require 'react' # to use md2react
Radium = require 'radium'
md2react = require 'md2react'

class OverviewComponent extends React.Component
  
  constructor: (props) ->
    super props
  @contextTypes:
    ctx: React.PropTypes.any

  render: ->
    $ = React.createElement
    markdown = "# Hello md2react\n\n# Hello md2react\n\n# Hello md2react\n\n# Hello md2react\n\n"
    reactMd = md2react markdown, gfm:true, breaks: true
    
    $ 'div', className: 'markdown-content',
      reactMd


module.exports = Radium OverviewComponent

