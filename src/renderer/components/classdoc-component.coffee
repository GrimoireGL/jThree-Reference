React = require 'react'
Radium = require 'radium'
Route = require './route-component'
ListComponent = require './list-component'
DocContainerComponent = require './doc-container-component'
DocDetailContainerComponent = require './doc-detail-container-component'
DocSlideWrapperComponent = require './doc-slide-wrapper-component'

class ClassDocComponent extends React.Component
  constructor: (props) ->
    super props

  _onChange: ->
    @setState @store.get()

  componentWillMount: ->
    @store = @context.ctx.docStore
    @setState @store.get()

  componentDidMount: ->
    @store.onChange @_onChange.bind(@)

  # shouldComponentUpdate: (np, ns) ->
  #   console.log 'ClassDoc update'
  #   console.log np, @props
  #   console.log ns, @state
  #   return true

  componentWillUnmount: ->
    @store.removeChangeListener(@_onChange.bind(@))

  render: ->
    # console.log "render ClassDoc", (+new Date()).toString()[-4..-1]
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <div style={styles.list}>
        <Route>
          <ListComponent dir_tree={@state.dir_tree} />
        </Route>
      </div>
      <div style={styles.container}>
        <Route style={styles.doc_wrapper}>
          <DocSlideWrapperComponent>
            <DocContainerComponent style={styles.doc_container} doc_data={@state.doc_data} />
            <DocDetailContainerComponent style={styles.doc_detail_container} doc_data={@state.doc_data} />
          </DocSlideWrapperComponent>
        </Route>
      </div>
    </div>

styles =
  base:
    display: 'flex'
    display: '-webkit-flex'
    flexDirection: 'row'
    WebkitFlexDirection: 'row'
    flexWrap: 'nowrap'
    WebkitFlexWrap: 'nowrap'

  list:
    boxSizing: 'border-box'
    paddingLeft: 10
    paddingTop: 10
    width: 360
    minWidth: 360
    borderRightWidth: 1
    borderRightColor: '#ccc'
    borderRightStyle: 'solid'
    position: 'fixed'
    top: 80
    height: 'calc(100% - 80px)'
    overflowY: 'scroll'
    overflowX: 'hidden'
    zIndex: 10
    backgroundColor: '#fff'

  container:
    flexGrow: '1'
    WebkitFlexGrow: '1'
    display: 'flex'
    display: '-webkit-flex'
    flexDirection: 'column'
    WebkitFlexDirection: 'column'
    flexWrap: 'nowrap'
    WebkitFlexWrap: 'nowrap'
    marginLeft: 360
    # minWidth: 800

  doc_wrapper:
    display: 'flex'
    display: '-webkit-flex'
    flexDirection: 'row'
    WebkitFlexDirection: 'row'
    flexWrap: 'nowrap'
    WebkitFlexWrap: 'nowrap'
    flexGrow: '1'
    WebkitFlexGrow: '1'

  doc_container: {}

  doc_detail_container:
    flexGrow: '1'
    WebkitFlexGrow: '1'

ClassDocComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ClassDocComponent
