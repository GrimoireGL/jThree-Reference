objectAssign = require 'object-assign'

class RoutesGen
  constructor: (json) ->
    @json = json
    @routes = {}
    @constructRoutes()

  updateJson: (json) ->
    @json = json
    @constructRoutes()

  constructRoutes: ->
    @routes = {}
    @routes = objectAssign(@routes, @constructClassRoutes())
    @routes = objectAssign(@routes, @constructErrorRoutes())

  constructClassRoutes: ->
    prefix = 'class'
    routes = {}
    @json.children.forEach (child, i) ->
      dir = child.name.replace(/\"/g, '')
      dir_arr = dir.split('/')
      dir_arr.forEach (d, j) ->
        if j != dir_arr.length - 1
          routes["#{prefix}/#{dir_arr[0..j].join('/')}"] = "#{prefix}:global"
        else
          child.groups?.forEach (group) ->
            group.children.forEach (id) ->
              child.children.forEach (gchild) ->
                if gchild.id == id
                  routes["#{prefix}#{if dir_arr.length == 1 then '' else '/' + dir_arr[0..(j - 1)].join('/')}/#{gchild.name}"] = "#{prefix}:global:#{child.id}:#{gchild.id}"
    routes["#{prefix}"] = "#{prefix}"
    return routes

  constructErrorRoutes: ->
    routes = {
      '.*' : 'error'
    }
    return routes

module.exports = RoutesGen
