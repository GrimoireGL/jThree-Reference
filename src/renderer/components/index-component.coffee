React = require 'react'
Radium = require 'radium'
colors = require './colors/color-definition'
Link = require './link-component'
{A,H2,P,H3,Li,Ul,Th,Tr,Thead,Td,Tbody,Table,Strong,Span,Code,Pre,Div} = require './index-extend-components'

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
              <span style={styles.logo_jthree}>jThree</span><span style={styles.logo_v3}>β</span>
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
          <Li>Have Enjoyable contributions ❤️</Li>
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
        <P>Thank you for your interest in contributions!  ❤️</P>
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

        <Pre>
          <Code>
            &lt;!DOCTYPE html&gt;
            &lt;html&gt;
            &lt;head&gt;
              &lt;script type=&quot;text/goml&quot;&gt;
                &lt;goml&gt;
                  &lt;resources&gt;
                    &lt;cube name=&quot;cube&quot; /&gt;
                  &lt;/resources&gt;
                  &lt;canvases&gt;
                    &lt;canvas clearColor=&quot;purple&quot; frame=&quot;.canvasContainer&quot;&gt;
                      &lt;viewport cam=&quot;CAM1&quot; id=&quot;main&quot; width=&quot;640&quot; height=&quot;480&quot; name=&quot;MAIN&quot;/&gt;
                    &lt;/canvas&gt;
                  &lt;/canvases&gt;
                  &lt;scenes&gt;
                    &lt;scene name=&quot;mainScene&quot;&gt;
                      &lt;object rotation=&quot;y(30d)&quot;&gt;
                        &lt;camera id=&quot;maincam&quot; aspect=&quot;1&quot; far=&quot;20&quot; fovy=&quot;1/2p&quot; name=&quot;CAM1&quot; near=&quot;0.1&quot;
                                position=&quot;(0,8,10)&quot; rotation=&quot;x(-30d)&quot;&gt;&lt;/camera&gt;
                      &lt;/object&gt;
                      &lt;scenelight color=&quot;#FFF&quot; intensity=&quot;1&quot;  top=&quot;40&quot;  far=&quot;50&quot; right=&quot;50&quot; position=&quot;-10,-10,10&quot;/&gt;
                      &lt;mesh id=&quot;cube&quot; geo=&quot;cube&quot; mat=&quot;red&quot;/&gt;
                    &lt;/scene&gt;
                  &lt;/scenes&gt;
                &lt;/goml&gt;
              &lt;/script&gt;
            &lt;/head&gt;
            &lt;body&gt;
            &lt;/body&gt;
            &lt;/html&gt;
          </Code>
        </Pre>
      </Div>
    </Div>

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
