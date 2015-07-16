React = require 'react'
Radium = require 'radium'
colors = require './colors/color-definition'

###
@props.list [required] list array of search target
@props.style
###
class DocIncrementalComponent extends React.Component
  constructor: (props) ->
    super props

  componentWillMount: ->
    list = @props.list
    @setState
      text: ''
      result: []
      list: list
    process.nextTick =>
      @setState
        list: list.sort()
      @updateSearch('')

  updateText: (e) ->
    text = e.target.value
    @setState
      text: text
    process.nextTick =>
      @updateSearch(text)

  updateSearch: (text) ->
    result = []
    md_all_completely = []
    md_all_forward = []
    md_all = []
    md_part = []
    regexp_all = new RegExp('^(.*?)(' + text + ')(.*?)$', 'i')
    regexp = new RegExp('^(.*?)(' + text.split('').join(')(.*?)(') + ')(.*?)$', 'i')
    dstyle = [styles.default, styles.emphasis]
    for l in @state.list
      match = l.match(regexp)
      if match
        match_all = l.match(regexp_all)
        if match_all
          if match_all[1] == ''
            if match_all[match_all.length - 1] == ''
              md_all_completely.push match_all
            else
              md_all_forward.push match_all
          else
            md_all.push match_all
        else
          md_part.push match
    md_result = [].concat md_all_completely, md_all_forward, md_all, md_part
    for md in md_result[0..9]
      elm = []
      for m, i in md[1..-1]
        elm.push <span style={dstyle[i % 2]}>{m}</span> if m != ''
      result.push <span>{elm}</span>
    @setState
      result: result

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <input type="text" value={@state.text} onChange={@updateText.bind(@)} />
      <ul>
        {
          for l in @state.result
            <li><span>{l}</span></li>
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

DocIncrementalComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocIncrementalComponent
