fs = require 'fs'
config = require './stateInitializer/initializeStateConfig'

class Docs
  constructor: ->
    @json = JSON.parse(fs.readFileSync(config.typedoc.path_to_json))

  getGlobalClassById: (id) ->
    for group, i in @json.groups
      if group.title == "External modules"
        index = group.children.indexOf parseInt(id, 10)
        if index != -1
          return @json.children[index]
    return null

module.exports = Docs
