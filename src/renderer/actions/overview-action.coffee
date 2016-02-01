Flux = require 'material-flux'
keys = require '../keys'
request = require 'superagent'
Promise = require 'bluebird'

class OverviewAction extends Flux.Action
  ###*
   * flux action for overview
   * @return {OverviewAction}
  ###
  constructor: ->
    super

  ###*
   * get and update overview object
   * @param  {String|Number} title_id   id of child of overview root
  ###
  updateOverview: (path) ->
    path = path.split("/").filter((_, i) -> i >= 2).join(":::")
    new Promise (resolve, reject) =>
      request
        .get "/api/overview/root:::#{path}"
        .end (err, res) ->
          # console.log "connect to: ", "/api/overview/#{path}"
          # console.log "res.body: ", res.body
          # console.log err
          resolve res.body
    .then (res) =>
      debugger
      @dispatch(keys.updateOverview, path, res)
    .catch (err) ->
      console.error err

module.exports = OverviewAction
