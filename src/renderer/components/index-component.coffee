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
              <object style={styles.logo_svg} data='/static/img/jthree-logo.svg' type='image/svg+xml'></object>
            </div>
            <div style={styles.logo_text}>
              <span style={styles.logo_jthree}>jThree</span><span style={styles.logo_v3}>v3</span>
            </div>
          </div>
          <div style={styles.description}>
            <span>The simpler Web3D,the more interesting.</span>
          </div>
        </div>
      </div>
      <div style={styles.wrapper}>
        <div style={styles.link_container}>
          <a href='//github.com/jThreeJS/jThree' style={styles.link} key='github'>
            <div style={styles.link_icon_wrap}>
              <span className='icon-mark-github'></span>
            </div>
            <div style={styles.link_label}>Github</div>
            <div style={styles.link_desc}>jThree hosts sources in Github.Your any contributions are welcome!</div>
          </a>
        </div>
        <div style={styles.link_container}>
          <Link href='/overview' style={styles.link} key='overview'>
            <div style={styles.link_icon_wrap}>
              <span className='icon-earth'></span>
            </div>
            <div style={styles.link_label}>OverView</div>
            <div style={styles.link_desc}>Tutorials, tags, tips. Share your code and stock your idea.</div>
          </Link>
        </div>
        <div style={styles.link_container}>
          <Link href='/class' style={styles.link} key='reference'>
            <div style={styles.link_icon_wrap}>
              <span className='icon-books'></span>
            </div>
            <div style={styles.link_label}>Reference</div>
            <div style={styles.link_desc}>jThree API reference. Search classes, methods, properties...</div>
          </Link>
        </div>
        <div style={styles.link_container}>
          <a href='//forum.jthree.io' style={styles.link} key='forum'>
            <div style={styles.link_icon_wrap}>
              <span className='icon-bubbles'></span>
            </div>
            <div style={styles.link_label}>Forum</div>
            <div style={styles.link_desc}>Discuss your problem with jThree community members. Official announcement will be posted here.</div>
          </a>
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
    WebkitTransform: 'translate(-50%, -50%)'
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
    height: 210

  logo_svg:
    width: 200
    opacity: 0.8
    WebkitFilter: 'drop-shadow(0 0 2px rgba(0, 0, 0, 0.5))'
    filter: 'drop-shadow(0 0 2px rgba(0, 0, 0, 0.5))'

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
    WebkitFlexDirection: 'row'
    flexWrap: 'nowrap'
    WebkitFlexWrap: 'nowrap'
    justifyContent: 'space-around'
    WebkitJustifyContent: 'space-around'

  link_container:
    boxSizing: 'border-box'
    paddingTop: 20
    paddingBottom: 20
    paddingRight: 20
    paddingLeft: 20
    width: 300

  link:
    display: 'block'
    textDecoration: 'none'
    cursor: 'pointer'
    transitionProperty: 'all'
    transitionDuration: '0.1s'
    transitionTimingFunction: 'ease-in-out'

    ':hover':
      opacity: '0.8'

  link_icon_wrap:
    fontSize: 50
    textAlign: 'center'
    color: colors.main.n.default

  link_label:
    fontSize: 20
    textAlign: 'center'
    color: colors.main.n.default

  link_desc:
    marginTop: 10
    fontSize: 13
    textAlign: 'center'
    color: colors.main.n.moderate

IndexComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium IndexComponent
