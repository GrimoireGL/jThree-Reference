fs = require 'fs'

###*
 * configuration of stateInitializer
 * @type {Object}
###
module.exports =
  typedoc:
    path_to_json: './src/server/doc.json'
  example:
    markdown: './src/server/examples.md'
    path_to_json: './src/server/example.json'
  router:
    root: '/'
