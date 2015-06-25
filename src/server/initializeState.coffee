RoutesGen = require './stateInitializer/routes-gen'
config = require './stateInitializer/initializeStateConfig'
DirTree = require './stateInitializer/dir-tree'
Docs = require './docs'
Router = require '../renderer/lib/router'

class InitializeState
  constructor: ->
    @docs = new Docs()
    @routesGen = new RoutesGen(@docs.json)
    @router = new Router(config.router.root, @routesGen.routes)

  initialize: (req) ->
    initial_doc_data = {}
    @router.route req.originalUrl, (route, argu) =>
      id = argu.route_arr[2]
      if id?
        initial_doc_data[id.toString()] = @docs.getGlobalClassById(id)
    initialState =
      RouteStore:
        fragment: req.originalUrl
        root: config.router.root
        routes: @routesGen.routes
      DocStore:
        dir_tree: new DirTree(@docs.json).dir_tree
        doc_data: initial_doc_data
    return initialState

module.exports = InitializeState
