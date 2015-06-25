require('source-map-support').install()
express = require 'express'
fs = require 'fs'
Handlebars = require 'handlebars'
React = require 'react'
Context = require './renderer/context'
Root = require './renderer/components/root-component'
InitializeState = require './server/initializeState'
Docs = require './server/docs'

server = express()

server.use '/static', express.static('public')

template = Handlebars.compile fs.readFileSync("#{fs.realpathSync('./')}/view/index.hbs").toString()

server.get '/favicon.ico', (req, res) ->

docs = new Docs()
initializeState = new InitializeState()

server.get '/api/class/global/:id', (req, res) ->
  console.log req.originalUrl
  res.json docs.getGlobalClassById req.params.id

server.get '*', (req, res) ->
  console.log req.originalUrl
  initialStates = initializeState.initialize(req)
  context = new Context(initialStates)
  res.send template
    initialStates: JSON.stringify initialStates
    markup: React.renderToString React.createElement(Root, {context})

server.listen (process.env.PORT || 5000)
