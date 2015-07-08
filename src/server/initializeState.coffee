RoutesGen = require './stateInitializer/routes-gen'
config = require './stateInitializer/initializeStateConfig'
DirTree = require './stateInitializer/dir-tree'
Docs = require './docs'
Router = require '../renderer/lib/router'

class InitializeState
  constructor: (docs) ->
    @docs = docs
    @routeGen = new RoutesGen()
    @dirTree = new DirTree()
    @router = new Router(config.router.root, @routeGen.routes)

  gen: ->
    @routeGen.gen @docs.json
    @dirTree.gen @docs.json
    @router.setRoute @routeGen.routes

  initialize: (req) ->
    initial_doc_data = {}
    @router.route req.originalUrl, (route, argu) =>
      file_id = argu.route_arr[2]?.toString()
      factor_id = argu.route_arr[3]?.toString()
      if file_id? && factor_id?
        initial_doc_data = @docs.getDocDataById file_id, factor_id
    initialState =
      RouteStore:
        fragment: req.originalUrl
        root: config.router.root
        routes: @router.routes
      DocStore:
        dir_tree: @dirTree.dir_tree
        doc_data: initial_doc_data
    return initialState

module.exports = InitializeState
