require('source-map-support').install() if process.env.NODE_ENV == 'development'
express = require 'express'
favicon = require 'serve-favicon'
fs = require 'fs'
Handlebars = require 'handlebars'
React = require 'react'
Context = require './renderer/context'
Root = require './renderer/components/root-component'
InitializeState = require './server/initializeState'
Docs = require './server/docs'
Overviews = require './server/overviews'

console.log "environment: #{process.env.NODE_ENV}"

server = express()

server.use '/static', express.static('public')
server.use favicon("#{fs.realpathSync('./')}/public/assets/favicon/favicon.ico")

template = Handlebars.compile fs.readFileSync("#{fs.realpathSync('./')}/view/index.hbs").toString()

docs = new Docs()
overviews = new Overviews()

initializeState = new InitializeState(docs)
docs.getJsonScheduler 3 * 60 * 60, ->
  initializeState.gen()


###*
 * API for get doc data
 * @param  {Object} req express request object
 * @param  {Object} res express response object
 * @return {[type]}     [description]
###
server.get '/api/class/global/:file_id/:factor_id', (req, res) ->
  console.log req.originalUrl
  res.json docs.getDocDataById req.params.file_id, req.params.factor_id

server.get '/overviewtexts/:title_id', (req, res) ->
  console.log req.originalUrl
  res.json
    markdown: overviews.getMarkdownById(req.params.title_id)
    structure: overviews.getTitleStructure

###*
 * All page view request routing is processed here
 * generate view by React server-side rendering
 * @param  {Object} req express request object
 * @param  {Object} res express response object
###
server.get '*', (req, res) ->
  console.log req.originalUrl
  initialStates = initializeState.initialize(req)
  context = new Context(initialStates)
  res.send template
    initialStates: JSON.stringify initialStates
    markup: React.renderToString React.createElement(Root, {context})


console.log 'running on', 'PORT:', (process.env.PORT || 5000), 'IP:', process.env.IP

server.listen(process.env.PORT || 5000, process.env.IP)
