React = require 'react'
Radium = require 'radium'
Route = require './route-component'
ListComponent = require './list-component'
DocContainerComponent = require './doc-container-component'
DocDetailContainerComponent = require './doc-detail-container-component'

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
          <DocContainerComponent style={styles.doc_container} doc_data={@state.doc_data} />
          <DocDetailContainerComponent style={styles.doc_detail_container} doc_data={@state.doc_data} />
        </Route>
      </div>
    </div>

styles =
  base:
    paddingLeft: 10
    paddingRight: 10
    display: 'flex'
    flexDirection: 'row'
    flexWrap: 'nowrap'
  list:
    width: 350
    minWidth: 350
    borderRightWidth: 1
    borderRightColor: '#ccc'
    borderRightStyle: 'solid'
  container:
    flexGrow: '1'
    display: 'flex'
    flexDirection: 'column'
    flexWrap: 'nowrap'
  doc_wrapper:
    display: 'flex'
    flexDirection: 'row'
    flexWrap: 'nowrap'
    flex: '1'
  doc_container: {}
  doc_detail_container:
    flexGrow: '1'

ClassDocComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ClassDocComponent
