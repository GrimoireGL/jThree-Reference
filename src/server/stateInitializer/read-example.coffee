fs = require 'fs'
conf = require './initializeStateConfig'

module.exports = ->
  fs.readFileSync conf.examples.markdown, 'utf8'