React = require 'react'
Radium = require 'radium'
Route = require './route-component'
Link = require './link-component'
colors = require './colors/color-definition'

class HeaderComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <div style={styles.base}>
      <div style={styles.head}>
        <span style={styles.title}>jThree</span>
        <span style={styles.subtitle}>Reference</span>
      </div>
      <nav style={styles.nav}>
        <Route addStyle={styles.active} style={styles.li_cont}>
          <li route='index' key='index' style={[styles.li]}>
            <Link href='/' style={styles.link}>Top</Link>
          </li>
          <li route='overview' key='overview' style={[styles.li, styles.left_separator]}>
            <Link href='/overview' style={styles.link}>Overview</Link>
          </li>
          <li route='class' key='class' style={[styles.li, styles.left_separator]}>
            <Link href='/class' style={styles.link}>Reference</Link>
          </li>
        </Route>
      </nav>
    </div>

styles =
  base:
    backgroundColor: colors.main.n.default
    height: 80
    position: 'relative'
    WebkitUserSelect: 'none'
    MozUserSelect: 'none'

  head:
    position: 'absolute'
    top: '50%'
    transform: 'translateY(-50%)'
    left: 40

  title:
    color: colors.main.r.emphasis
    marginRight: 20
    fontSize: 30
    fontWeight: 'bold'
    cursor: 'default'

  subtitle:
    color: colors.main.r.default
    cursor: 'default'

  nav:
    position: 'absolute'
    top: '50%'
    transform: 'translateY(-50%)'
    right: 40

  active:
    color: colors.main.r.emphasis

  li_cont:
    clear: 'both'
    overflow: 'hidden'

  li:
    listStyle: 'none'
    float: 'left'
    paddingLeft: 20
    paddingRight: 20

  left_separator:
    borderLeftColor: colors.main.r.moderate
    borderLeftStyle: 'solid'
    borderLeftWidth: 1

  link:
    textDecoration: 'none'
    color: colors.main.r.default

    ':hover':
      color: colors.main.r.emphasis

HeaderComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium HeaderComponent
