###
@providesModule Docs
###

fs = require 'fs'
config = require './stateInitializer/initializeStateConfig'


###
Convert TypeDoc json to Docs object

@param {string} path to json
###
class Docs
  constructor: (path)->
    @json = JSON.parse(fs.readFileSync(path || config.typedoc.path_to_json))

  ###
  get global class typedoc json as object

  @param {string|number} id of doc
  @api public
  ###
  getGlobalClassById: (id) ->
    for group, i in @json.groups
      if group.title == "External modules"
        index = group.children.indexOf parseInt(id, 10)
        if index != -1
          return @json.children[index]
    return null

module.exports = Docs
