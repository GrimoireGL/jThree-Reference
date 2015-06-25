React = require 'react'
Route = require './route-component'
Link = require './link-component'
DocContainerComponent = require './doc-container-component'
_ = require 'lodash'

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

  constructNestedList: (dir_tree, traced) ->
    traced ||= []
    <div>
      <ul>
        {
          return_elm = []
          if dir_tree.dir?
            for dir, tree of dir_tree.dir
              return_elm.push do =>
                traced_ = _.clone(traced, true)
                traced_.push dir
                <li key={dir}>
                  <span>{dir}</span>
                  {
                    @constructNestedList(tree, traced_)
                  }
                </li>
          if dir_tree.file?
            for file, id of dir_tree.file
              return_elm.push do ->
                traced_ = _.clone(traced, true)
                traced_.push file
                <li key={file}>
                  {
                    <Link href={"/class/#{traced_.join('/')}"}>{file}</Link>
                  }
                </li>
          return_elm
        }
      </ul>
    </div>

  render: ->
    <div>
      <div>
        {
          @constructNestedList(@state.dir_tree)
        }
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
