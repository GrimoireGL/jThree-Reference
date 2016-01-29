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
  updateOverview: (title_id) ->
    new Promise (resolve, reject) =>
      request
        .get "/api/overview/#{title_id}"
        .end (err, res) ->
          # resolve res.body
    .then (res) =>
      @dispatch(keys.updateOverview, res)
    .catch (err) ->
      console.error err

module.exports = OverviewAction
