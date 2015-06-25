Flux = require 'material-flux'
keys = require '../keys'
request = require 'superagent'
Promise = require 'bluebird'

class DocAction extends Flux.Action
  constructor: ->
    super

  updateDoc: (id) ->
    console.log id
    new Promise (resolve, reject) =>
      request
        .get "/api/class/global/#{id}"
        .end (err, res) ->
          if res.ok
            resolve res.body
          else
            reject err
    .then (res) =>
      console.log res
      @dispatch(keys.updateDoc, id, res)
    .catch (err) ->
      console.error err

module.exports = DocAction
