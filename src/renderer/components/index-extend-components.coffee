# A,H2,P,H3,Li,Ul,Th,Tr,Thead,Td,Tbody,Table,Strong,Span,Code,Pre,Div,

React = require 'react'
Radium = require 'radium'
colors = require './colors/color-definition'


###*
# style setting
###
styles = 
  # a: 

  h2:
    fontSize: 40
    padding: '0 10px'
    borderBottom: '2px solid #5d8bc1'
    marginTop: 100
  h3:
    fontSize: 30
    ext: 
      color: colors.main.n.default
  # p:
  # li:
  # ul:
  th:
    borderBottom: "2px solid #5d8bc1"
    margin: 5
    textAlign: 'center'
    padding: '14px 20px'


  tr:
    textAlign: 'center'


  # thead:
  td:
    padding: '14px 20px'

  # tbody:
  table:
    borderCollapse: 'separate'
    border: 'none'
    backgroundColor: 'rgba(255,255,255, 0.8)'
    padding: 8
  # strong:
  # span:
  code:
    fontFamily: 'CamingoCode, consolas, lucida'
  pre:
    backgroundColor: 'white'
    borderRadius: 3
    border: '1px solid #eee'
    padding: '8px 20px'
  # div:




$ = React.createElement

componentAry = [
  class A extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'a', href: @props.href, style: Array.prototype.concat.apply([], [this.props.style,styles.a]),
        @props.children
  ,
  class H2 extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'h2', style: Array.prototype.concat.apply([], [this.props.style,styles.h2]),
        @props.children
  ,
  class H3 extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'h3', style: Array.prototype.concat.apply([], [this.props.style,styles.h3]),
        $ 'span', style: styles.h3.ext,
          '- '
        @props.children
        $ 'span', style: styles.h3.ext,
          ' -'
  ,
  class P extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'p', style: Array.prototype.concat.apply([], [this.props.style,styles.p]),
        @props.children
  ,
  class Li extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'li', style: Array.prototype.concat.apply([], [this.props.style,styles.li]),
        @props.children
  ,      
  class Ul extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'ul', style: Array.prototype.concat.apply([], [this.props.style,styles.ul]),
        @props.children
  ,
  class Th extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'th', style: Array.prototype.concat.apply([], [this.props.style,styles.th]),
        @props.children
  ,
  class Tr extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'tr', style: Array.prototype.concat.apply([], [this.props.style,styles.tr]),
        @props.children
  ,
  class Thead extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'thead', style: Array.prototype.concat.apply([], [this.props.style,styles.thead]),
        @props.children
  ,
  class Td extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'td', style: Array.prototype.concat.apply([], [this.props.style,styles.td]),
        @props.children
  ,
  class Tbody extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'tbody', style: Array.prototype.concat.apply([], [this.props.style,styles.tbody]),
        @props.children
  ,
  class Table extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'table', style: Array.prototype.concat.apply([], [this.props.style,styles.table]),
        @props.children
  ,
  class Strong extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'strong', style: Array.prototype.concat.apply([], [this.props.style,styles.strong]),
        @props.children
  ,
  class Span extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'span', style: Array.prototype.concat.apply([], [this.props.style,styles.span]),
        @props.children
  ,
  class Code extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'code', style: Array.prototype.concat.apply([], [this.props.style,styles.code]),
        @props.children
  ,
  class Pre extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'pre', style: Array.prototype.concat.apply([], [this.props.style,styles.pre]),
        @props.children
  ,
  class Div extends React.Component
    constructor: (props) ->
      super props
    render: ->
      $ 'div', style: Array.prototype.concat.apply([], [this.props.style,styles.div]),
        @props.children
]

components = {}
componentAry
  .map (Component) ->
    Component.contextTypes =
      ctx: React.PropTypes.any
    Component
  .forEach (Component) -> 
    components[Component.name] = Radium(Component)

console.log components
module.exports = components

