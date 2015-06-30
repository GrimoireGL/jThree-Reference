RoutesGen = require './stateInitializer/routes-gen'
config = require './stateInitializer/initializeStateConfig'
DirTree = require './stateInitializer/dir-tree'
Docs = require './docs'
Router = require '../renderer/lib/router'

class InitializeState
  constructor: ->
    @docs = new Docs()
    @routes = new RoutesGen(@docs.json).routes
    @dir_tree = new DirTree(@docs.json).dir_tree
    @router = new Router(config.router.root, @routes)

  initialize: (req) ->
    initial_doc_data = {}
    @router.route req.originalUrl, (route, argu) =>
      file_id = argu.route_arr[2]?.toString()
      factor_id = argu.route_arr[3]?.toString()
      if file_id? && factor_id?
        initial_doc_data[file_id] ||= {}
        initial_doc_data[file_id][factor_id] = @docs.getGlobalClassById(file_id, factor_id)
    initialState =
      RouteStore:
        fragment: req.originalUrl
        root: config.router.root
        routes: @routes
      DocStore:
        dir_tree: @dir_tree
        doc_data: initial_doc_data
    return initialState

module.exports = InitializeState
