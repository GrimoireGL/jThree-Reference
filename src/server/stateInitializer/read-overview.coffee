fs = require 'fs'
conf = require './initializeStateConfig'

module.exports = ->
  fs.readFileSync conf.overview.markdown, 'utf8'