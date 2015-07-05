React = require 'react'
Radium = require 'radium'
Route = require './route-component'
DocContainerComponent = require './doc-container-component'
ListComponent = require './list-component'

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
    <div style={styles.base}>
      <div style={styles.list}>
        <Route>
          <ListComponent dir_tree={@state.dir_tree} />
        </Route>
      </div>
      <div style={styles.container}>
        <Route>
          <DocContainerComponent doc_data={@state.doc_data} />
        </Route>
      </div>
    </div>

styles =
  base:
    paddingTop: 10
    paddingBottom: 10
    paddingLeft: 10
    paddingRight: 10
    display: 'flex'
    flexDirection: 'row'
    flexWrap: 'nowrap'
  list:
    width: 350
  container:
    flexGrow: '1'

ClassDocComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ClassDocComponent
