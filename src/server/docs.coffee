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

  @param {string|number} id of child of doc root
  @param {string|number} id of grandchild of doc root
  @api public
  ###
  getGlobalClassById: (file_id, factor_id) ->
    for child in @json.children
      if child.id == parseInt(file_id, 10)
        for gchild in child.children
          if gchild.id == parseInt(factor_id, 10)
            console.log gchild.name
            return gchild
    return null

module.exports = Docs
