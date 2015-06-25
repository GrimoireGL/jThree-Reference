React = require 'react'
Context = require './renderer/context'
Root = require './renderer/components/root-component'

initialStates = JSON.parse document.getElementById('initial-states').getAttribute('states-json')

console.log initialStates

context = new Context(initialStates)

React.render React.createElement(Root, {context}), document.getElementById("app")
