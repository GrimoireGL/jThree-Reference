###
@providesModule Docs
###

fs = require 'fs'
config = require './stateInitializer/initializeStateConfig'
clone = require 'lodash.clone'
request = require 'request'
Promise = require 'bluebird'
marked = require 'marked'


class Overviews
  ###*
   * Convert Overviews object from markdown text
   * @return {Overviews}
  ###
  constructor: ->
    @markdown = fs.readFileSync config.overview.markdown, 'utf8'
    @lines = @markdown.split "\n"

    # @markdown = ""
    # @lines = []
    # _getLocalMarkdown()

  ###*
   * set external markdown text
   * @param {Object} overview markdown text
  ###
  # setMarkdown: (md) ->
  #   @markdown = md

  ###*
   * load markdown from this server
  ###
  _getLocalMarkdown = ->
    @markdown = fs.readFileSync config.overview.markdown, 'utf8'
    @lines = @markdown.split "\n"

  getTitleStructure: ->
    # console.log @lines
    structData = @lines
      .map (line, i) ->
        _getTitleData line, i
      .filter (o) ->
        (!!o.level) && (!!o.title)
    # console.log structData
    structData

  getTitleCount: ->
    @getTitleStructure()
      .filter (o) ->
        o.level == 1
      .length

  _getTitleData = (line, lineNumber) -> # 行数は0から数えるものとする
    titleRegex = /^\s*#+\s*(.+)/g
    levelRegex = /^\s*(#+)\s*/g
    title = (
      titleRegex.exec(line) ||
      1: null
    )[1]
    titleLevel = (
      levelRegex.exec(line) ||
      1: length: 0
    )[1].length # execにはマッチする「#」達が入るからそのlengthがタイトルのレベル
    return {
      title: title
      level: titleLevel
      lineNumber: lineNumber
    }

  getMarkdownById: (title_id) ->
    lineNumber = 0
    texts = []
    len = undefined
    while len != 0
      txt = @getMdDataByLineNumber(lineNumber)
      texts.push txt
      len = txt.split("\n").length - 1
      lineNumber += len + 1
      # console.log txt, len, lineNumber
    # console.log texts
    texts[title_id]

  getOverviewHtml: (title_id) ->
    markdown = @getMarkdownById title_id
    marked.setOptions highlight: (code) ->
      require('highlight.js').highlightAuto(code).value
    html = marked markdown

  getMdDataByLineNumber: (titleLineNumber) -> # 次に見つかる大見出しまたはEOFを見つける
    startLine = titleLineNumber
    nextLine = startLine + 1
    while !(@lines[nextLine] == undefined || _getTitleData(@lines[nextLine], nextLine).level == 1)
      nextLine++
    endLine = nextLine - 1
    resultMd = @lines
      .filter (s, i) ->
        startLine <= i && i <= endLine
      .join "\n"
    resultMd


module.exports = Overviews
