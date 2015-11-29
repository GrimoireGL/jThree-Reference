React = require 'react'
Radium = require 'radium'
Route = require './route-component'
Link = require './link-component'
ProgressbarComponent = require './progressbar-component'

class DocCoverageComponent extends React.Component
  constructor: (props) ->
    super props

  _onChange: ->
    @setState @store.get()

  componentWillMount: ->
    @store = @context.ctx.docCoverageStore
    @setState @store.get()

  componentDidMount: ->
    @store.onChange @_onChange.bind(@)

  componentWillUnmount: ->
    @store.removeChangeListener(@_onChange.bind(@))

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <ProgressbarComponent percentage={@state.coverage.covered * 100 / @state.coverage.all}>
        Coverage
      </ProgressbarComponent>
    </div>

styles =
  base: {}

DocCoverageComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocCoverageComponent
