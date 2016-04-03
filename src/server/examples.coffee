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


class Examples
  ###*
   * Convert Examples object from markdown text
   * @return {Examples}
  ###
  constructor: ->
    @json = JSON.parse fs.readFileSync config.example.path_to_json, 'utf8'
    @structure = @getStructure()
    @routes = @getRoutes()
    # @markdown = fs.readFileSync config.example.markdown, 'utf8'
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
      console.log "ExampleRoutes", routes
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
          routesAry.push("example#{pwd}/#{o.file}")
        when "directory"
          routesAry = routesAry.concat(_recursionSearch(o, "#{pwd}/#{o.name}"))
    routesAry

  getMarkupByPath: (path) ->
    # path is splitted by aaaa
    pathAry = path.split "aaaa"
    return @md2Html @findMarkdown(@json, pathAry)

  findMarkdown: (dir, pathAry) =>
    if pathAry.length # 検索するものが残ってる->ディレクトリ
      findedDir = dir.children.filter((o) =>
        @titleToUrl(o.file||"") == pathAry[0] ||
        @titleToUrl(o.name||"") == pathAry[0]
      )[0]
      pathAry.shift()
      return @findMarkdown findedDir, pathAry
    # 残ってない->ファイル
    return dir.content

  md2Html: (markdown) ->
    marked.setOptions highlight: (code) ->
      require('highlight.js').highlightAuto(code).value
    return html = marked markdown

module.exports = Examples
