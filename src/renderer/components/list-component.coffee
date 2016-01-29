React = require 'react'
Radium = require 'radium'
Link = require './link-component'
ListFolderComponent = require './list-folder-component'
ListItemComponent = require './list-item-component'
CharIconComponent = require './char-icon-component'
colors = require './colors/color-definition'

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
                <ListFolderComponent folded={folded} name={dir}>
                  <ListItemComponent type='folder' style={styles.item} name={dir}>
                    <span style={styles.item_text}>
                      <span style={styles.clickable}>{dir}</span>
                    </span>
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
            highlight = top.path.every (v, i) =>
              v == @props.argu.fragment_arr[1..top.path.length][i]
            highlight_styles = {}
            if highlight
              highlight_styles =
                wrap:
                  backgroundColor: colors.main.n.moderate
                content:
                  color: colors.main.r.emphasis
            return_elm.push do =>
              <li key={file}>
                <ListItemComponent style={styles.item} update={highlight} name={top.name}>
                  <CharIconComponent char={top.kindString[0]} style={[@genKindStringStyle(top.kindString), styles.icon]} />
                  <span style={[styles.item_text, highlight_styles.wrap]}>
                    <Link href={"/class/#{top.path.join('/')}"} style={[styles.clickable, styles.link, highlight_styles.content]}>{top.name}</Link>
                  </span>
                </ListItemComponent>
              </li>
        return_elm
      }
    </ul>

  genKindStringStyle: (kindString) ->
    color = colors.general.r.default

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
        color = colors.general.r.default

    style =
      color: color
      borderColor: color

    return style

  shouldComponentUpdate: (nextProps, nextState) ->
    return @props.argu.route != nextProps.argu.route

  render: ->
    # console.log "render List", (+new Date()).toString()[-4..-1]
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        @constructNestedList(@props.dir_tree)
      }
    </div>

styles =
  base: {}

  ul:
    listStyle: 'none'
    paddingLeft: 22

  clickable:
    cursor: 'pointer'

  link:
    textDecoration: 'none'
    color: colors.general.r.default

  item:
    display: 'flex'
    flexDirection: 'row'
    WebkitFlexDirection: 'row'
    flexWrap: 'nowrap'
    WebkitFlexWrap: 'nowrap'

  icon:
    fontWeight: 'normal'
    cursor: 'default'

  item_text:
    paddingTop: 5
    paddingLeft: 6
    marginRight: 10
    flexGrow: '1'
    WebkitFlexGrow: '1'

ListComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium ListComponent
