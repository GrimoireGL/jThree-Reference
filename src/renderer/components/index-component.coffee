React = require 'react'
Radium = require 'radium'
colors = require './colors/color-definition'
Link = require './link-component'
{A,H2,P,H3,Li,Ul,Th,Tr,Thead,Td,Tbody,Table,Strong,Span,Code,Pre,Div} = require './index-extend-components'
Loading = require './loading-component'

# console.log("A is ",A.name)

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
              <span style={styles.logo_jthree}>jThree</span><span style={styles.logo_v3}>α</span>
            </div>
          </div>
          <div style={styles.description}>
            <span>Focus on the most important.</span>
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
            <div style={styles.link_desc}>jThree hosts sources in Github. Your any contributions are welcome!</div>
          </a>
        </div>
        <div style={styles.link_container}>
          <Link href='/example' style={styles.link} key='example'>
            <div style={styles.link_icon_wrap}>
              <span className='icon-earth'></span>
            </div>
            <div style={styles.link_label}>Examples</div>
            <div style={styles.link_desc}>Share your code and stock your idea.</div>
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
      </div>
      <div>
        {
          @introduction()
        }
      </div>
    </div>

  introduction: () ->
    <Div style={styles.introduction.wrap}>
      <Div style={styles.introduction.body} class="index-introduction">
        <H2><A id="What_is_jThree_0"></A>What is jThree?</H2>
        <P>jThree is an innovative 3D graphics engine. It may seem to be just a javascript library.
          However, jThree will enable browser to use most of the feature as other game engines do in local environment, plugins features,hierarchies,templates,modUle systems.
        </P>
        <H3><A id="Purposes_6"></A>Purposes</H3>
        <Ul>
          <Li>Provide a good learning resource for the beginners to know how programming is awesome via this library.</Li>
          <Li>Sharing features that will be achieved easily by this library implemented with javascript.</Li>
          <Li>Redefine legacies of 3DCG technologies on the Internet.</Li>
          <Li>Have Enjoyable contributions</Li>
        </Ul>
        <H3><A id="Dependencies_14"></A>Dependencies</H3>
        <P>This library depends on the following libraries. We appreciate these contributors below</P>
        <Table>
          <Thead>
            <Tr>
              <Th style={width:100}>Name</Th>
              <Th style={width:300}>Purpose</Th>
              <Th style={width:300}>URL</Th>
            </Tr>
          </Thead>
          <Tbody>
            <Tr>
              <Td>gl-matrix</Td>
              <Td>Use for calcUlation for webgl</Td>
              <Td><A href="https://github.com/toji/gl-matrix">https://github.com/toji/gl-matrix</A></Td>
            </Tr>
          </Tbody>
        </Table>
        <H2><A id="Contributions_23"></A>Contributions</H2>
        <P>Thank you for your interest in contributions!</P>
        <A href="https://jthree-slackin.herokuapp.com/"><img src="/static/img/jthree-slack.png"/></A>
        <H3><A id="Installation_to_build_28"></A>Installation to build</H3>
        <P>You need the applications below.</P>
        <Ul>
          <Li>node.js</Li>
          <Li>npm</Li>
        </Ul>
        <P>You need <Strong>not</Strong> to install any packages in global.</P>
        <P>You need to run the command below to install npm packages,bower packages,and so on in local environment.</P>
        <Pre>
          <Code class="language-shell">
            $ npm install
          </Code>
        </Pre>
        <P><Strong>That is all you need to do for preparation!</Strong></P>
        <P>Then, run the command below to build “j3.js”</P>
        <Pre>
          <Code class="language-shell">
            $ npm run build
          </Code>
        </Pre>
        <Table>
          <Thead>
            <Tr>
              <Th style={width:100}>command</Th>
              <Th style={width:400}>description</Th>
            </Tr>
          </Thead>
          <Tbody>
            <Tr>
              <Td>npm run build</Td>
              <Td>build “j3.js”</Td>
            </Tr>
            <Tr>
              <Td>npm run test</Td>
              <Td>run test</Td>
            </Tr>
            <Tr>
              <Td>npm run watch</Td>
              <Td>watch files for build and run simple web server(under wwwroot)</Td>
            </Tr>
            <Tr>
              <Td>npm start</Td>
              <Td>only run simple web server(under wwwroot)</Td>
            </Tr>
          </Tbody>
        </Table>
        <P>(simple web server supported LiveReload)</P>
        <H3>Example</H3>

        <P>Look at this simple example.</P>
        <div className="markdown-component toppage" dangerouslySetInnerHTML={{__html: @code()}}></div>
      </Div>
    </Div>

  code: ->
    return """
      <pre><code class="lang-xml">
        <span class="hljs-meta">&lt;!DOCTYPE html&gt;</span>
        <span class="hljs-tag">&lt;<span class="hljs-name">html</span> <span class="hljs-attr">lang</span>=<span class="hljs-string">"en"</span>&gt;</span>
          <span class="hljs-tag">&lt;<span class="hljs-name">head</span>&gt;</span>
            <span class="hljs-tag">&lt;<span class="hljs-name">meta</span> <span class="hljs-attr">charset</span>=<span class="hljs-string">"utf-8"</span>/&gt;</span>
            <span class="hljs-tag">&lt;<span class="hljs-name">script</span> <span class="hljs-attr">type</span>=<span class="hljs-string">"text/javascript"</span> <span class="hljs-attr">src</span>=<span class="hljs-string">"j3.js"</span>&gt;</span><span class="undefined"></span><span class="hljs-tag">&lt;/<span class="hljs-name">script</span>&gt;</span>
          <span class="hljs-tag">&lt;/<span class="hljs-name">head</span>&gt;</span>
          <span class="hljs-tag">&lt;<span class="hljs-name">body</span>&gt;</span>
            <span class="hljs-tag">&lt;<span class="hljs-name">div</span> <span class="hljs-attr">class</span>=<span class="hljs-string">"iframe-theme"</span>&gt;</span>
              <span class="hljs-tag">&lt;<span class="hljs-name">div</span> <span class="hljs-attr">class</span>=<span class="hljs-string">"container"</span>&gt;</span>
                <span class="hljs-tag">&lt;<span class="hljs-name">div</span> <span class="hljs-attr">id</span>=<span class="hljs-string">"canvas"</span> <span class="hljs-attr">class</span>=<span class="hljs-string">"canvasContainer"</span>/&gt;</span>
              <span class="hljs-tag">&lt;/<span class="hljs-name">div</span>&gt;</span>
            <span class="hljs-tag">&lt;/<span class="hljs-name">div</span>&gt;</span>
            <span class="hljs-tag">&lt;<span class="hljs-name">script</span> <span class="hljs-attr">type</span>=<span class="hljs-string">"text/goml"</span>&gt;</span><span class="handlebars"><span class="xml">
              <span class="hljs-tag">&lt;<span class="hljs-name">goml</span>&gt;</span>
                <span class="hljs-tag">&lt;<span class="hljs-name">resources</span>&gt;</span>
                  <span class="hljs-tag">&lt;<span class="hljs-name">material</span> <span class="hljs-attr">name</span>=<span class="hljs-string">"sampleMaterial1"</span> <span class="hljs-attr">type</span>=<span class="hljs-string">"builtin.solid"</span> <span class="hljs-attr">color</span>=<span class="hljs-string">"yellow"</span>/&gt;</span>
                  <span class="hljs-tag">&lt;<span class="hljs-name">material</span> <span class="hljs-attr">name</span>=<span class="hljs-string">"sampleMaterial2"</span> <span class="hljs-attr">type</span>=<span class="hljs-string">"builtin.solid"</span> <span class="hljs-attr">color</span>=<span class="hljs-string">"green"</span>/&gt;</span>
                  <span class="hljs-tag">&lt;<span class="hljs-name">material</span> <span class="hljs-attr">name</span>=<span class="hljs-string">"sampleMaterial3"</span> <span class="hljs-attr">type</span>=<span class="hljs-string">"builtin.solid"</span> <span class="hljs-attr">color</span>=<span class="hljs-string">"blue"</span>/&gt;</span>
                  <span class="hljs-tag">&lt;<span class="hljs-name">material</span> <span class="hljs-attr">name</span>=<span class="hljs-string">"sampleMaterial4"</span> <span class="hljs-attr">type</span>=<span class="hljs-string">"builtin.solid"</span> <span class="hljs-attr">color</span>=<span class="hljs-string">"red"</span>/&gt;</span>
                  <span class="hljs-tag">&lt;<span class="hljs-name">material</span> <span class="hljs-attr">name</span>=<span class="hljs-string">"sampleMaterial5"</span> <span class="hljs-attr">type</span>=<span class="hljs-string">"builtin.solid"</span> <span class="hljs-attr">color</span>=<span class="hljs-string">"orange"</span>/&gt;</span>
                <span class="hljs-tag">&lt;/<span class="hljs-name">resources</span>&gt;</span>
                <span class="hljs-tag">&lt;<span class="hljs-name">canvases</span>&gt;</span>
                  <span class="hljs-tag">&lt;<span class="hljs-name">canvas</span> <span class="hljs-attr">clearColor</span>=<span class="hljs-string">"#11022A"</span> <span class="hljs-attr">frame</span>=<span class="hljs-string">".canvasContainer"</span>&gt;</span>
                    <span class="hljs-tag">&lt;<span class="hljs-name">viewport</span> <span class="hljs-attr">cam</span>=<span class="hljs-string">"CAM1"</span> <span class="hljs-attr">id</span>=<span class="hljs-string">"main"</span> <span class="hljs-attr">width</span>=<span class="hljs-string">"640"</span> <span class="hljs-attr">height</span>=<span class="hljs-string">"480"</span>/&gt;</span>
                  <span class="hljs-tag">&lt;/<span class="hljs-name">canvas</span>&gt;</span>
                <span class="hljs-tag">&lt;/<span class="hljs-name">canvases</span>&gt;</span>
                <span class="hljs-tag">&lt;<span class="hljs-name">scenes</span>&gt;</span>
                  <span class="hljs-tag">&lt;<span class="hljs-name">scene</span> <span class="hljs-attr">name</span>=<span class="hljs-string">"mainScene"</span>&gt;</span>
                    <span class="hljs-tag">&lt;<span class="hljs-name">camera</span> <span class="hljs-attr">id</span>=<span class="hljs-string">"maincam"</span> <span class="hljs-attr">aspect</span>=<span class="hljs-string">"1"</span> <span class="hljs-attr">far</span>=<span class="hljs-string">"20"</span> <span class="hljs-attr">fovy</span>=<span class="hljs-string">"1/3p"</span> <span class="hljs-attr">name</span>=<span class="hljs-string">"CAM1"</span> <span class="hljs-attr">near</span>=<span class="hljs-string">"0.1"</span> <span class="hljs-attr">position</span>=<span class="hljs-string">"(0,8,10)"</span> <span class="hljs-attr">rotation</span>=<span class="hljs-string">"x(-30d)"</span>&gt;</span><span class="hljs-tag">&lt;/<span class="hljs-name">camera</span>&gt;</span>
                    <span class="hljs-tag">&lt;<span class="hljs-name">mesh</span> <span class="hljs-attr">mat</span>=<span class="hljs-string">"sampleMaterial1"</span> <span class="hljs-attr">geo</span>=<span class="hljs-string">"cube"</span> <span class="hljs-attr">position</span>=<span class="hljs-string">"2,0,0"</span>/&gt;</span>
                    <span class="hljs-tag">&lt;<span class="hljs-name">mesh</span> <span class="hljs-attr">mat</span>=<span class="hljs-string">"sampleMaterial2"</span> <span class="hljs-attr">geo</span>=<span class="hljs-string">"sphere"</span> <span class="hljs-attr">position</span>=<span class="hljs-string">"4,0,0"</span>/&gt;</span>
                    <span class="hljs-tag">&lt;<span class="hljs-name">mesh</span> <span class="hljs-attr">mat</span>=<span class="hljs-string">"sampleMaterial3"</span> <span class="hljs-attr">geo</span>=<span class="hljs-string">"quad"</span> <span class="hljs-attr">position</span>=<span class="hljs-string">"0,0,0"</span>/&gt;</span>
                    <span class="hljs-tag">&lt;<span class="hljs-name">mesh</span> <span class="hljs-attr">mat</span>=<span class="hljs-string">"sampleMaterial4"</span> <span class="hljs-attr">geo</span>=<span class="hljs-string">"cone"</span> <span class="hljs-attr">position</span>=<span class="hljs-string">"-2,0,0"</span>/&gt;</span>
                    <span class="hljs-tag">&lt;<span class="hljs-name">mesh</span> <span class="hljs-attr">mat</span>=<span class="hljs-string">"sampleMaterial5"</span> <span class="hljs-attr">geo</span>=<span class="hljs-string">"cylinder"</span> <span class="hljs-attr">position</span>=<span class="hljs-string">"-4,0,0"</span>/&gt;</span>
                  <span class="hljs-tag">&lt;/<span class="hljs-name">scene</span>&gt;</span>
                <span class="hljs-tag">&lt;/<span class="hljs-name">scenes</span>&gt;</span>
              <span class="hljs-tag">&lt;/<span class="hljs-name">goml</span>&gt;</span>
            </span></span><span class="hljs-tag">&lt;/<span class="hljs-name">script</span>&gt;</span>
          <span class="hljs-tag">&lt;/<span class="hljs-name">body</span>&gt;</span>
        <span class="hljs-tag">&lt;/<span class="hljs-name">html</span>&gt;</span>
      </code></pre>
    """

styles =
  base:
    WebkitUserSelect: 'none'
    MozUserSelect: 'none'

  logo_area:
    backgroundColor: colors.main.n.default
    backgroundImage: "url('/static/img/jthreetop.png')"
    backgroundSize: 'auto 100%'
    backgroundPosition: 'center'
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
    # fontFamily
    paddingTop: 11
    paddingBottom: 15
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

  introduction:
    wrap:
      backgroundImage: 'url(http://subtlepatterns2015.subtlepatterns.netdna-cdn.com/patterns/cream_dust.png)'
      boxShadow: 'rgba(182, 194, 209, 0.33) 0px 27px 50px -18px inset'
      width: '100%'
      display: 'flex'
      justifyContent: 'center'
    body:
      width: 960




IndexComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium IndexComponent
