###
@providesModule Docs
###

fs = require 'fs'
config = require './stateInitializer/initializeStateConfig'
clone = require 'lodash.clone'
request = require 'request'
Promise = require 'bluebird'

class Overviews
  ###*
   * Convert Overviews object from markdown text
   * @return {Overviews}
  ###
  constructor: ->
    @markdown = ""
    @lines = []

  ###*
   * set external markdown text
   * @param {Object} overview markdown text
  ###
  # setMarkdown: (md) ->
  #   @markdown = md

  ###*
   * load markdown from this server
  ###
  getLocalMarkdown: ->
    @markdown = fs.readFileSync config.overview.markdown, 'utf8'
    @lines = @markdown.split "\n"

  getTitleStructure: ->
    structData = lines
      .map (line, i) ->
        getTitleData line, i
      .filter (o) ->
        !!o.length && !!o.title
    structData

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

  getMdDataById: (titleLineNumber) -> # 次に見つかる大見出しまたはEOFを見つける
    startLine = titleLineNumber
    nextLine = startLine + 1
    while @lines[nextLine] == undefined || _getTitleData(nextLine).level == 1
      nextLine++
    endLine = nextLine - 1
    resultMd = @lines
      .filter (s, i) ->
        startLine <= i && i <= endLine
      .join "\n"
    resultMd


module.exports = Overviews
