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
        routes["#{prefix}/#{dir_arr[0..j].join('/')}"] =
          if j != dir_arr.length - 1
            "#{prefix}:global"
          else
            "#{prefix}:global:#{child.id}"
    routes["#{prefix}"] = "#{prefix}"
    return routes

  constructErrorRoutes: ->
    routes = {
      '.*' : 'error'
    }
    return routes

module.exports = RoutesGen
