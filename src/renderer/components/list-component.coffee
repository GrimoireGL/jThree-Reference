React = require 'react'
Radium = require 'radium'
Link = require './link-component'
ListFolderComponent = require './list-folder-component'
ListItemComponent = require './list-item-component'
CharIconComponent = require './char-icon-component'

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
                  <ListItemComponent type='folder'>
                    <span style={styles.clickable}>{dir}</span>
                  </ListItemComponent>
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
                  <CharIconComponent char={top.kindString[0]} color='333' />
                  <Link href={"/class/#{top.path.join('/')}"} style={[styles.clickable, styles.link]}>{top.name}</Link>
                </ListItemComponent>
              </li>
        return_elm
      }
    </ul>

  render: ->
    <div style={styles.wrapper}>
      {
        @constructNestedList(@props.dir_tree)
      }
    </div>

styles =
  ul:
    listStyle: 'none'
    paddingLeft: 20
  wrapper:
    width: 400
  clickable:
    cursor: 'pointer'
  link:
    textDecoration: 'none'

ListComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ListComponent
