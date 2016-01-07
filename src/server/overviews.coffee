###
@providesModule Docs
###

fs = require 'fs'
config = require './stateInitializer/initializeStateConfig'
clone = require 'lodash.clone'
request = require 'request'
Promise = require 'bluebird'
marked = require 'marked'
objectAssign = require 'object-assign'


class Overviews
  ###*
   * Convert Overviews object from markdown text
   * @return {Overviews}
  ###
  constructor: ->
    @json = JSON.parse fs.readFileSync config.overview.path_to_json, 'utf8'
    @structure = @getStructure()
    @routes = @getRoutes()
    # @markdown = fs.readFileSync config.overview.markdown, 'utf8'
    # @lines = @markdown.split "\n"

  getStructure: ->
    dir = @json
    return @parseStructure _recursionSearch dir

  getRoutes: ->
    dir = @json
    routes = {}
    _recursionSearch(dir).forEach (title) =>
      fragment = @titleToUrl title
      route = fragment.replace /\//g, ':'
      routes[fragment] = route
    console.log routes
    return routes

  titleToUrl: (title) ->
    title
      .replace /^\s+/g, ""
      .replace /\s+$/g, ""
      .replace /\s/g, "-"
      .toLowerCase()

  parseStructure: (routesAry) =>
    routesAry.map (pwd) =>
      size = pwd.split('/').length
      title: pwd.split('/')[size - 1]
      url: "/#{@titleToUrl(pwd)}"
      level: size - 1

  _recursionSearch = (directory, pwd) ->
    pwd = pwd || ""
    routesAry = []
    directory.children.forEach (o) ->
      switch o.type
        when "file"
          routesAry.push("overview#{pwd}/#{o.file}")
        when "directory"
          routesAry = routesAry.concat(_recursionSearch(o, "#{pwd}/#{o.name}"))
    routesAry

  getMarkupByPath: (path) ->
    # path is splitted by :::
    pathAry = path.split ":::"
    # console.log @md2Html @findMarkdown(@json, pathAry)
    return @md2Html @findMarkdown(@json, pathAry)

  findMarkdown: (dir, pathAry) =>
    # console.log pathAry
    if pathAry.length # 検索するものが残ってる->ディレクトリ
      findedDir = dir.children.filter((o) =>
        @titleToUrl(o.file||"") == pathAry[0] ||
        @titleToUrl(o.name||"") == pathAry[0]
      )[0]
      pathAry.shift()
      # console.log findedDir
      return @findMarkdown findedDir, pathAry
    # 残ってない->ファイル
    # console.log dir.content
    return dir.content

  md2Html: (markdown) ->
    marked.setOptions highlight: (code) ->
      require('highlight.js').highlightAuto(code).value
    return html = marked markdown





  # ###*
  #  * set external markdown text
  #  * @param {Object} overview markdown text
  # ###
  # # setMarkdown: (md) ->
  # #   @markdown = md
  #
  # getTitleStructure: ->
  #   # console.log @lines
  #   structData = @lines
  #     .map (line, i) ->
  #       _getTitleData line, i
  #     .filter (o) ->
  #       (!!o.level) && (!!o.title)
  #   # console.log structData
  #   structData
  #
  # getTitleArray: ->
  #   self = @
  #
  #   structure = @getTitleStructure()
  #   prev =
  #     parent: null
  #     children: []
  #     level: 0
  #     title: null
  #   root = prev.children
  #   structure.forEach (o, i) ->
  #     relativeDepth = prev.level - o.level + 1  # p = 0, o = 1 -> 0
  #     target = prev
  #     [0...(relativeDepth)].forEach (j) ->
  #       target = target.parent
  #     o =
  #       parent: target
  #       children: []
  #       level: o.level
  #       title: self.toUrl(o.title)
  #     target.children.push o
  #     prev = o
  #   # console.log "tree: ", root
  #   root
  #
  # getTitles: ->
  #   @getTitleStructure()
  #     .filter (o) -> o.level == 1
  #     .map    (o) -> o.title
  #
  # toUrl: (str) ->
  #   str
  #     .replace /^\s+/g, ""
  #     .replace /\s+$/g, ""
  #     .replace /\s/g, "-"
  #     .toLowerCase()
  #
  # # getUrls: ->
  # #   @getTitles()
  # #     .map (title) ->
  # #       title
  # #         .replace /^\s+/g, ""
  # #         .replace /\s+$/g, ""
  # #         .replace /\s/g, "-"
  # #         .toLowerCase()
  #
  # _getTitleData = (line, lineNumber) -> # 行数は0から数えるものとする
  #   titleRegex = /^\s*#+\s*(.+)/g
  #   levelRegex = /^\s*(#+)\s*/g
  #   title = (
  #     titleRegex.exec(line) ||
  #     1: null
  #   )[1]
  #   titleLevel = (
  #     levelRegex.exec(line) ||
  #     1: length: 0
  #   )[1].length # execにはマッチする「#」達が入るからそのlengthがタイトルのレベル
  #   return {
  #     title: title
  #     level: titleLevel
  #     lineNumber: lineNumber
  #   }
  #
  #
  #
  # getMarkdownById: (title_id) ->
  #   lineNumber = 0
  #   texts = []
  #   len = undefined
  #   while len != 0
  #     txt = @getMdDataByLineNumber(lineNumber)
  #     texts.push txt
  #     len = txt.split("\n").length - 1
  #     lineNumber += len + 1
  #     # console.log txt, len, lineNumber
  #   # console.log texts
  #   texts[title_id]
  #
  # getOverviewHtml: (title_id) ->
  #   markdown = @getMarkdownById title_id
  #   marked.setOptions highlight: (code) ->
  #     require('highlight.js').highlightAuto(code).value
  #   html = marked markdown
  #
  # getMdDataByLineNumber: (titleLineNumber) -> # 次に見つかる大見出しまたはEOFを見つける
  #   startLine = titleLineNumber
  #   nextLine = startLine + 1
  #   while !(@lines[nextLine] == undefined || _getTitleData(@lines[nextLine], nextLine).level == 1)
  #     nextLine++
  #   endLine = nextLine - 1
  #   resultMd = @lines
  #     .filter (s, i) ->
  #       startLine <= i && i <= endLine
  #     .join "\n"
  #   resultMd


module.exports = Overviews
