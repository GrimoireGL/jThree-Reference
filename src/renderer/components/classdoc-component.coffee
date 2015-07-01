React = require 'react'
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
    <div>
      <div>
        <ListComponent dir_tree={@state.dir_tree} />
      </div>
      <div>
        <Route>
          <DocContainerComponent doc_data={@state.doc_data} />
        </Route>
      </div>
    </div>

ClassDocComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = ClassDocComponent
