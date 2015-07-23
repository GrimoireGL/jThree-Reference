Flux = require 'material-flux'
keys = require '../keys'
request = require 'superagent'
Promise = require 'bluebird'

class DocAction extends Flux.Action
  ###*
   * flux action for doc
   * @return {DocAction}
  ###
  constructor: ->
    super

  ###*
   * get and update doc object
   * @param  {String|Number} file_id   id of child of doc root
   * @param  {String|Number} factor_id id of grandchild of doc root
  ###
  updateDoc: (file_id, factor_id) ->
    # console.log 'request', (+new Date()).toString()[-4..-1]
    new Promise (resolve, reject) =>
      request
        .get "/api/class/global/#{file_id}/#{factor_id}"
        .end (err, res) ->
          if res.ok
            resolve res.body
          else
            reject err
    .then (res) =>
      # console.log res
      # console.log 'request end', (+new Date()).toString()[-4..-1]
      @dispatch(keys.updateDoc, res)
    .catch (err) ->
      console.error err

module.exports = DocAction
