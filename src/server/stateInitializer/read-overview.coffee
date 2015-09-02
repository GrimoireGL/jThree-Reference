fs = require 'fs'
conf = require './initializeStateConfig.coffee'

module.exports = ->
  fs.readFileSync conf.overview.markdown, 'utf8'