React = require 'react'
Radium = require 'radium'
colors = require './colors/color-definition'
Link = require './link-component'

class IndexComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <div style={styles.base}>
      <div style={styles.logo_area}>
        <div style={styles.logo_wrapper}>
          <div style={styles.logo}>
            <div style={styles.logo_icon}>
              <span className='icon-cube'></span>
            </div>
            <div style={styles.logo_text}>
              <span style={styles.logo_jthree}>jThree</span><span style={styles.logo_v3}>v3</span>
            </div>
          </div>
          <div style={styles.description}>
            <span>The more simple, the more Web3D is interesting.</span>
          </div>
        </div>
      </div>
      <div style={styles.wrapper}>
        <div style={styles.container} key='overview'>
          <Link href='/overview' style={styles.link}>
            <div style={styles.icon_wrap}>
              <span className='icon-earth'></span>
            </div>
            <div style={styles.label}>OverView</div>
          </Link>
        </div>
        <div style={styles.container} key='reference'>
          <Link href='/class' style={styles.link}>
            <div style={styles.icon_wrap}>
              <span className='icon-books'></span>
            </div>
            <div style={styles.label}>Reference</div>
          </Link>
        </div>
      </div>
    </div>

styles =
  base:
    WebkitUserSelect: 'none'
    MozUserSelect: 'none'

  logo_area:
    backgroundColor: colors.main.n.default
    height: 500
    position: 'relative'

  logo_wrapper:
    position: 'absolute'
    top: '50%'
    left: '50%'
    transform: 'translate(-50%, -50%)'
    paddingBottom: 30
    cursor: 'default'

  logo:
    fontSize: 50

  logo_jthree:
    fontWeight: 'bold'
    marginRight: 20
    color: colors.main.r.emphasis
    textShadow: '0 0 2px rgba(0, 0, 0, 0.5)'

  logo_v3:
    fontSize: 30
    paddingTop: 13
    paddingBottom: 10
    paddingLeft: 13
    paddingRight: 13
    backgroundColor: colors.main.r.emphasis
    color: colors.main.n.default
    boxShadow: '0 0 2px 0 rgba(0, 0, 0, 0.5)'
    borderRadius: 4

  logo_icon:
    textAlign: 'center'
    fontSize: 180
    height: 210
    color: colors.main.r.emphasis
    textShadow: '0 0 2px rgba(0, 0, 0, 0.5)'

  logo_text:
    textAlign: 'center'

  description:
    textAlign: 'center'
    color: colors.main.r.default
    fontSize: 18
    marginTop: 20

  wrapper:
    paddingTop: 50
    paddingBottom: 50
    paddingRight: 100
    paddingLeft: 100
    display: 'flex'
    flexDirection: 'row'
    flexWrap: 'nowrap'
    justifyContent: 'space-around'

  container:
    paddingTop: 20
    paddingBottom: 20
    paddingRight: 20
    paddingLeft: 20

  link:
    textDecoration: 'none'
    color: colors.main.n.default
    cursor: 'pointer'
    transitionProperty: 'all'
    transitionDuration: '0.1s'
    transitionTimingFunction: 'ease-in-out'

    ':hover':
      color: colors.main.n.moderate

  icon_wrap:
    fontSize: 50
    textAlign: 'center'

  label:
    fontSize: 20
    textAlign: 'center'

IndexComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium IndexComponent
