React = require 'react'
Radium = require 'radium'
colors = require './colors/color-definition'
DocIncrementalSearchComponent = require './doc-incremental-search-component'

###
@props.style
###
class DocSearchContainerComponent extends React.Component
  constructor: (props) ->
    super props

  componentWillMount: ->
    @store = @context.ctx.routeStore
    state = @store.get()
    @setState
      routes: state.routes

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        list = []
        for fragment, route of @state.routes
          list.push fragment.match(/.+\/(.+)$/)[1] if route.split(':')[1] == 'global'
        <DocIncrementalSearchComponent list={list} />
      }
      {
        list = []
        for fragment, route of @state.routes
          list.push fragment.match(/.+\/(.+)$/)[1] if route.split(':')[1] == 'local'
        <DocIncrementalSearchComponent list={list} />
      }
    </div>

styles =
  base: {}

DocSearchContainerComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocSearchContainerComponent
