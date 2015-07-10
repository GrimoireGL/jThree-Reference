objectAssign = require 'object-assign'

class RoutesGen
  constructor: (json) ->
    @routes = {}
    @_constructRoutes json

  gen: (json) ->
    @_constructRoutes json

  _constructRoutes: (json) ->
    @routes = {}
    @routes = objectAssign(@routes, constructClassRoutes(json))
    @routes = objectAssign(@routes, constructErrorRoutes())

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

  constructErrorRoutes = ->
    routes = {
      '.*' : 'error'
    }
    return routes

module.exports = RoutesGen
