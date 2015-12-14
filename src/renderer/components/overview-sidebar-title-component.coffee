React = require 'react'
Radium = require 'radium'
Link = require './link-component'

class OverviewSidebarTitleComponent extends React.Component

  constructor: (props) ->
    super props

  titleToUrl: (title) ->
    title
      .replace /^\s+/, ""
      .replace /\s+$/, ""
      .replace /\s/, "-"

  render: ->
    <div style={[].concat([], styles.titleBox[@props.level-1], @props.style)}>
      {
        if @props.level == 1
          <Link style={styles.titleText[1]} href={"/overview/#{@titleToUrl(@props.children)}"}>
            {@props.children}
          </Link>
        else
          <a style={styles.titleText[@props.level-1]} href={"/overview/#{@titleToUrl(@props.root)}##{@titleToUrl(@props.children)}"}>
            {@props.children}
          </a>
      }
    </div>

styles =
  titleText: [
    {
      fontSize: 24
    },
    {
      fontSize: 20
    },
    {
      fontSize: 16
    }
  ]
  titleBox: [
    {
      # borderTop: "1px solid #999"
      # borderBottom: "1px solid #999"
      marginTop: 20
      background: "#f2f2f2"
      padding: "10px 15px"
    },
    {
      paddingLeft: "22px"
    },
    {
      paddingLeft: "30px"
    }
  ]

OverviewSidebarTitleComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewSidebarTitleComponent
