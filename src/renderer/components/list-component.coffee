React = require 'react'
Radium = require 'radium'
Link = require './link-component'
ListFolderComponent = require './list-folder-component'
ListItemComponent = require './list-item-component'

class ListComponent extends React.Component
  constructor: (props) ->
    super props

  constructNestedList: (dir_tree) ->
    <ul style={styles.ul}>
      {
        return_elm = []
        if dir_tree.dir?
          for dir, tree of dir_tree.dir
            return_elm.push do =>
              <li key={dir}>
                <ListFolderComponent>
                  <ListItemComponent type='folder'>{dir}</ListItemComponent>
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
                <ListItemComponent>
                  <Link href={"/class/#{top.path.join('/')}"}>{"(#{top.kindString}) #{top.name}"}</Link>
                </ListItemComponent>
              </li>
        return_elm
      }
    </ul>

  render: ->
    @constructNestedList(@props.dir_tree)

styles =
  ul:
    listStyle: 'none'

ListComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ListComponent
