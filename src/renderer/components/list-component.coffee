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
            folded = !tree.path.every (v, i) =>
              v == @props.argu.fragment_arr[1..tree.path.length][i]
            return_elm.push do =>
              <li key={dir}>
                <ListFolderComponent folded={folded}>
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
            return_elm.push do =>
              <li key={file}>
                <ListItemComponent>
                  <CharIconComponent char={top.kindString[0]} style={[@genIconStyle(top.kindString), styles.icon]} />
                  <Link href={"/class/#{top.path.join('/')}"} style={[styles.clickable, styles.link]}>{top.name}</Link>
                </ListItemComponent>
              </li>
        return_elm
      }
    </ul>

  genIconStyle: (kindString) ->
    color = '#333333'

    switch kindString
      when 'Class'
        color = '#337BFF'
      when 'Interface'
        color = '#598213'
      when 'Enumeration'
        color = '#B17509'
      when 'Module'
        color = '#D04C35'
      when 'Function'
        color = '#6E00FF'
      else
        color = '#333333'

    style =
      color: color
      borderColor: color

    return style

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.wrapper, @props.style])}>
      {
        @constructNestedList(@props.dir_tree)
      }
    </div>

styles =
  ul:
    listStyle: 'none'
    paddingLeft: 22

  wrapper:
    borderRightWidth: 1
    borderRightColor: '#ccc'
    borderRightStyle: 'solid'

  clickable:
    cursor: 'pointer'

  link:
    textDecoration: 'none'
    color: '#333'

  icon:
    fontWeight: 'normal'
    cursor: 'default'

ListComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ListComponent
