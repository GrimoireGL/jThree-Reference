objectAssign = require 'object-assign'

class RoutesGen
  ###*
   * Routes generator
   * @param  {Object} json typedoc json
   * @return {RoutesGen}
  ###
  constructor: (json) ->
    @routes = {}
    # @_constructRoutes json

  ###*
   * regenerate routes
   * @param  {Object} json typedoc json
   * @return {Object}      routes
  ###
  gen: (classJson, examplesStructure) ->
    @_constructRoutes classJson, examplesStructure

  ###*
   * construct routes
   * @param  {Object} json typedoc json
   * @return {Object}      merged fragment of routes
  ###
  _constructRoutes: (classJson, examplesStructure) ->
    @routes = {}
    @routes = objectAssign {}, @routes, constructClassRoutes(classJson)
    @routes = objectAssign {}, @routes, constructIndexRoutes()
    @routes = objectAssign {}, @routes, constructExamplesRoutes(examplesStructure)
    @routes = objectAssign {}, @routes, constructErrorRoutes()

  ###*
   * construct class route
   * @param  {Object} json typedoc json
   * @return {Object}      fragment of routes
  ###
  constructClassRoutes = (json) ->
    prefix = 'class'
    routes = {}
    json?.children?.forEach (child, i) ->
      dir = child.name.replace(/\"/g, '')
      dir_arr = dir.split('/')
      dir_arr.forEach (d, j) ->
        if j != dir_arr.length - 1
          routes["#{prefix}/#{dir_arr[0..j].join('/')}"] = "#{prefix}:global"
        else
          child.children?.forEach (gchild) ->
            routes["#{prefix}#{if dir_arr.length == 1 then '' else '/' + dir_arr[0..(j - 1)].join('/')}/#{gchild.name}"] = "#{prefix}:global:#{child.id}:#{gchild.id}"
            gchild.children?.forEach (ggchild) ->
              routes["#{prefix}#{if dir_arr.length == 1 then '' else '/' + dir_arr[0..(j - 1)].join('/')}/#{gchild.name}/#{ggchild.name}"] = "#{prefix}:local:#{child.id}:#{gchild.id}:#{ggchild.id}"
    routes["#{prefix}"] = "#{prefix}"
    return routes

  ###*
   * construct index route
   * @return {Object} fragment of routes
  ###
  constructIndexRoutes = ->
    routes =
      '' : 'index'
    return routes

  ###*
   * construct examples route
   * @return {Object} fragment of routes
  ###
  constructExamplesRoutes = (structure) ->
    routes = structure
    routes["examples"] = "examples"
    # console.log routes
    return routes

  _recursionSearch = (directory, pwd) ->
    pwd = pwd || ""
    routes = {}
    directory.children.forEach (o) ->
      switch o.type
        when "file"
          routes["examples#{pwd}/#{o.file}"] = "examples#{pwd.replace /\//g, ':'}:#{o.file}"
        when "directory"
          routes = objectAssign(routes, _recursionSearch(o, "#{pwd}/#{o.name}"))
    routes

    # # todo: 後でリファクタリング
    # structure.forEach (node, i) ->
    #   routes["examples/#{node.title}"] = "examples:#{i}"
    #   if node.children?
    #     node.children.forEach (node2, j) ->
    #       routes["examples/#{node.title}/#{node2.title}"] = "examples:#{i}:#{j}"
    #       if node2.children
    #         node2.children.forEach (node3, k) ->
    #           routes["examples/#{node.title}/#{node2.title}/#{node3.title}"] = "examples:#{i}:#{j}:#{k}"
    # return routes

  ###*
   * construct error routes
   * @return {Object} fragment of routes
  ###
  constructErrorRoutes = ->
    routes =
      '.*' : 'error'
    return routes

module.exports = RoutesGen
