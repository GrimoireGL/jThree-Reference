fs = require 'fs'

###*
 * configuration of stateInitializer
 * @type {Object}
###
module.exports =
  typedoc:
    path_to_json: './src/server/doc.json'
  examples:
    markdown: './src/server/examples.md'
    path_to_json: './src/server/examples.json'
  router:
    root: '/'
