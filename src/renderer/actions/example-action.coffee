Flux = require 'material-flux'
keys = require '../keys'
request = require 'superagent'
Promise = require 'bluebird'

class ExampleAction extends Flux.Action
  ###*
   * flux action for example
   * @return {ExampleAction}
  ###
  constructor: ->
    super

  ###*
   * get and update example object
   * @param  {String|Number} title_id   id of child of example root
  ###
  updateExample: (path) ->
    path = path.split("/").join(":::")
    new Promise (resolve, reject) =>
      request
        .get "/api/example/root:::#{path}"
        .end (err, res) ->
          # console.log "connect to: ", "/api/example/#{path}"
          # console.log "res.body: ", res.body
          # console.log err
          resolve res.body
    .then (res) =>
      # debugger
      # console.log "path: ", path, "res: ", res
      @dispatch(keys.updateExample, path, res)
    .catch (err) ->
      console.error err

module.exports = ExampleAction
