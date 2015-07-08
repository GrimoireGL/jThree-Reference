###
@providesModule Docs
###

fs = require 'fs'
config = require './stateInitializer/initializeStateConfig'
clone = require 'lodash.clone'
request = require 'request'
Promise = require 'bluebird'

###
Convert TypeDoc json to Docs object

@param {string} path to json
###
class Docs
  constructor: (path)->
    @json = {}

  getJsonScheduler: (interval, cb) ->
    if process.env.NODE_ENV == 'production'
      @getDocsJson cb
    else if process.env.NODE_ENV == 'development'
      @json = JSON.parse(fs.readFileSync(config.typedoc.path_to_json))
      cb()
    console.log 'got json'
    setTimeout =>
      @getJsonScheduler interval, cb
    , interval * 1000

  getDocsJson: (cb) ->
    options =
      url: 'https://raw.githubusercontent.com/jThreeJS/jThree/gh-pages/docs/develop.json'
      json: true
    new Promise (resolve, reject) ->
      request.get options, (error, response, body) ->
        if !error && response.statusCode == 200
          resolve body
        else
          reject error
    .then (res) =>
      @json = res
      cb()
    .catch (err) ->
      console.log "get error: #{err}"

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

  ###
  get global file typedoc json as object not including children

  @param {string|number} id of child of doc root
  @api public
  ###
  getGlobalFileById: (file_id) ->
    for child in @json.children
      if child.id == parseInt(file_id, 10)
        c = clone child, true
        delete c.children
        delete c.groups
        return c
    return null

  ###
  Costruct doc_data object formed for doc store.

  @param {string|number} id of child of doc root
  @param {string|number} id of grandchild of doc root
  @api public
  ###
  getDocDataById: (file_id, factor_id) ->
    data = @getGlobalClassById(file_id, factor_id)
    from = @getGlobalFileById(file_id)
    doc_data = {}
    if from? && data?
      doc_data[file_id] = {}
      doc_data[file_id].from = from
      doc_data[file_id][factor_id] = data
    return doc_data

module.exports = Docs
