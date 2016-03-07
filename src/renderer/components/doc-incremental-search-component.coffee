React = require 'react'
Radium = require 'radium'
Link = require './link-component'
colors = require './colors/color-definition'

###
@props.list [required] list array contains hash
hash example:
{target: (string), content: [ReactElement, 'match', ...]}
target: target of search
content: elements array which is inserted to result list. if array factor
is 'match', it is replace to matched result element.
@props.style
@props.styles apply for each elements
###
class DocIncrementalComponent extends React.Component
  constructor: (props) ->
    super props

  componentWillMount: ->
    list = @props.list
    list.sort (v1, v2) -> if v1.target > v2.target then 1 else -1
    @setState
      text: ''
      result: []
      list: list
    @updateSearch('', list)

  componentDidMount: ->
    @refs.input.getDOMNode().focus()

  updateText: (e) ->
    text = e.target.value
    @setState
      text: text
    @updateSearch(text)

  keyDown: (e) ->
    if e.key == 'Enter' || e.code == 'Enter' || e.keyCode == 13
      e.preventDefault()
      @context.ctx.routeAction.navigate(@state.result[0].href) if @state.result[0]?

  updateSearch: (text, list) ->
    list ||= @state.list ? []
    text = text
      .replace /\s/g, ''
    result = []
    md_all_completely = []
    md_all_forward = []
    md_all = []
    md_part = []
    regexp_all = new RegExp('^(.*?)(' + text.replace(/([^0-9A-Za-z_])/g, '\\$1') + ')(.*?)$', 'i')
    regexp = new RegExp('^(.*?)(' + text.split('').map((v) -> v.replace(/([^0-9A-Za-z_])/g, '\\$1')).join(')(.*?)(') + ')(.*?)$', 'i')
    for l in list
      match = l.target.match(regexp)
      if match
        match_all = l.target.match(regexp_all)
        if match_all
          if match_all[1] == ''
            if match_all[match_all.length - 1] == ''
              md_all_completely.push
                match: match_all
                content: l.content
                href: l.href
            else
              md_all_forward.push
                match: match_all
                content: l.content
                href: l.href
          else
            md_all.push
              match: match_all
              content: l.content
              href: l.href
        else
          md_part.push
            match: match
            content: l.content
            href: l.href
    result = [].concat md_all_completely, md_all_forward, md_all, md_part
    @setState
      result: result

  render: ->
    dstyle = [styles.default, styles.emphasis]
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <input type="text" value={@state.text} onChange={@updateText.bind(@)} onKeyDown={@keyDown.bind(@)} style={@props.styles.input} placeholder='Search' ref='input' />
      <ul style={@props.styles.ul}>
        {
          return_elm = for md in @state.result[0..14]
            elm = []
            for m, i in md.match[1..]
              elm.push <span style={dstyle[i % 2]} key={i}>{m}</span> if m != ''
            <li style={@props.styles.li} key={md.href}>
              <span style={@props.styles.item}>
                {
                  for e, i in md.content
                    if e == 'match'
                      <Link href={md.href} style={[styles.link, @props.styles.match]} key='match'>{elm}</Link>
                    else
                      React.cloneElement e, {key: "icon-#{i}"}
                }
              </span>
            </li>
          if @state.result.length >= 16
            return_elm.push <li style={[styles.more, @props.styles.li]} key='more'><span>{"#{@state.result.length - 15} more"}</span></li>
          return_elm
        }
      </ul>
    </div>

styles =
  base: {}

  emphasis:
    color: colors.main.n.moderate
    fontWeight: 'bold'

  default:
    color: colors.general.r.moderate

  more:
    color: colors.general.r.light

  link:
    color: colors.general.r.moderate
    textDecoration: 'none'
    cursor: 'pointer'

    ':hover':
      textDecoration: 'underline'

DocIncrementalComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocIncrementalComponent
