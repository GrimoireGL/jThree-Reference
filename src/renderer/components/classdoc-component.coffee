React = require 'react'
Route = require './route-component'
Link = require './link-component'
DocContainerComponent = require './doc-container-component'
ListFolderComponent = require './list-folder-component'

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

  constructNestedList: (dir_tree) ->
    <div>
      <ul>
        {
          return_elm = []
          if dir_tree.dir?
            for dir, tree of dir_tree.dir
              return_elm.push do =>
                <li key={dir}>
                <ListFolderComponent>
                  <span type='folder'>{dir}</span>
                  <div type='children'>
                    {
                      @constructNestedList(tree)
                    }
                  </div>
                </ListFolderComponent>
                </li>
          if dir_tree.file?
            for file, top of dir_tree.file
              return_elm.push do ->
                <li key={file}>
                  {
                    <Link href={"/class/#{top.path.join('/')}"}>{"(#{top.kindString}) #{top.name}"}</Link>
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
