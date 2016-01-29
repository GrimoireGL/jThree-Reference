###
@providesModule Docs
###

fs = require 'fs'
config = require './stateInitializer/initializeStateConfig'
clone = require 'lodash.clone'
request = require 'request'
Promise = require 'bluebird'

class Docs
  ###*
   * Convert TypeDoc json to Docs object
   * @return {Docs}
  ###
  constructor: ->
    @json = {}

  ###*
   * set periodic interval timer to get json
   * @param  {Number}   interval timer interval (second)
   * @param  {Function} cb       callback function called on reseived json
  ###
  getJsonScheduler: (interval, cb) ->
    if process.env.NODE_ENV == 'production'
      @getRemoteJson cb
    else if process.env.NODE_ENV == 'development'
      @getLocalJson cb
    console.log 'got json'
    setTimeout =>
      @getJsonScheduler interval, cb
    , interval * 1000

  ###*
   * set external json object
   * @param {Object} json doc json object
  ###
  setJson: (json) ->
    @json = json

  ###*
   * load json from directory
   * @param  {Function} cb callback function on loaded
  ###
  getLocalJson: (cb) ->
    @json = JSON.parse(fs.readFileSync(config.typedoc.path_to_json))
    cb()

  ###*
   * request json
   * @param  {Function} cb callback function on resolved request
  ###
  getRemoteJson: (cb) ->
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

  ###*
   * get global class(factor) typedoc json as object
   * @param  {String|Number} file_id   id of child of doc root
   * @param  {String|Number} factor_id id of grandchild of doc root
   * @return {Object}                  object of specifyed class(factor) in typedoc
  ###
  getGlobalClassById: (file_id, factor_id) ->
    for child in @json.children
      if child.id == parseInt(file_id, 10)
        for gchild in child.children
          if gchild.id == parseInt(factor_id, 10)
            return gchild
    return null

  ###*
   * get global file typedoc json as object not including children
   * @param  {String|Number} file_id id of child of doc root
   * @return {Object}                object of specifyed file in typedoc
  ###
  getGlobalFileById: (file_id) ->
    for child in @json.children
      if child.id == parseInt(file_id, 10)
        c = clone child, true
        delete c.children
        delete c.groups
        return c
    return null

  ###*
   * Costruct doc_data object formed for doc store
   * @param  {String|Number} file_id   id of child of doc root
   * @param  {String|Number} factor_id id of grandchild of doc root
   * @return {Object}                  object of doc_data specifyed by id of file and factor
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
