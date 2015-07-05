React = require 'react'
Radium = require 'radium'
Route = require './route-component'
Link = require './link-component'

class HeaderComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <div style={styles.header}>
      <div style={styles.head}>
        <span style={styles.title}>jThree</span>
        <span style={styles.subtitle}>Reference</span>
      </div>
      <nav style={styles.nav}>
        <Route addStyle={styles.active} style={styles.li_cont}>
          <li route='index' key='0' style={[styles.li]}>
            <Link href='/' style={styles.link}>Overview</Link>
          </li>
          <li route='class' key='1' style={[styles.li, styles.left_separator]}>
            <Link href='/class' style={styles.link}>Reference</Link>
          </li>
        </Route>
      </nav>
    </div>

styles =
  header:
    backgroundColor: '#444'
    height: 80
    position: 'relative'
    WebkitUserSelect: 'none'

  head:
    position: 'absolute'
    top: '50%'
    transform: 'translateY(-50%)'
    left: 40

  title:
    color: '#eee'
    marginRight: 20
    fontSize: 30
    cursor: 'default'

  subtitle:
    color: '#ccc'
    cursor: 'default'

  nav:
    position: 'absolute'
    top: '50%'
    transform: 'translateY(-50%)'
    right: 40

  active: {}

  li_cont:
    clear: 'both'
    overflow: 'hidden'

  li:
    listStyle: 'none'
    float: 'left'
    paddingLeft: 20
    paddingRight: 20

  left_separator:
    borderLeftColor: '#aaa'
    borderLeftStyle: 'solid'
    borderLeftWidth: 1

  link:
    textDecoration: 'none'
    color: '#ccc'

HeaderComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium HeaderComponent
