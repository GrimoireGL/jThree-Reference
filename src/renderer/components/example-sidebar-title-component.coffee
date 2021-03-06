React = require 'react'
Radium = require 'radium'
Link = require './link-component'

class ExampleSidebarTitleComponent extends React.Component

  constructor: (props) ->
    super props

  render: ->
    <div style={[].concat([], styles.titleBox[@props.level-1], @props.style)}>
      {
        <Link style={styles.titleText[@props.level-1]} href={@props.url}>
          {@props.children}
        </Link>
        #   url = "/example/#{@titleToUrl(@props.itemTitle)}"
        #   if @props.level == 1
        #     # if @props.argu.fragment.match "#"
        #     #   url += "#"
        #   else
        #     url += "/" + @titleToUrl(@props.children)
        #   <Link style={styles.titleText[@props.level-1]} href={url}>
        #     {@props.children}
        #   </Link>
        #
      }
    </div>

styles =
  titleText: [
    {
      textDecoration: "none"
      color: "#000"
      fontSize: 17
      padding: 10
      borderBottom: "3px solid #ccc"
    },
    {
      textDecoration: "none"
      color: "#000"
      fontSize: 18
    },
    {
      textDecoration: "none"
      color: "#000"
      fontSize: 14
    }
  ]
  titleBox: [
    {
      # borderTop: "1px solid #999"
      # borderBottom: "1px solid #999"
      marginTop: 15
      marginBottom: 5
      # background: "#f2f2f2"
      textAlign: "right"
      padding: "10px 15px"
    },
    {
      paddingLeft: "22px"
      paddingTop: 5
      paddingBottom: 5
    },
    {
      paddingLeft: "30px"
    }
  ]

ExampleSidebarTitleComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ExampleSidebarTitleComponent
