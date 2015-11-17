RoutesGen = require './stateInitializer/routes-gen'
config = require './stateInitializer/initializeStateConfig'
DirTree = require './stateInitializer/dir-tree'
Docs = require './docs'
Router = require '../renderer/lib/router'
readOverview = require './stateInitializer/read-overview'
Overviews = require './overviews'

class InitializeState
  ###*
   * initialize state for stores in client
   * @return {InitializeState}
  ###
  constructor: (docs) ->
    @docs = docs
    @routeGen = new RoutesGen()
    @dirTree = new DirTree()
    @router = new Router(config.router.root, @routeGen.routes)
    @overviews = new Overviews()

  ###*
   * resetup state initializer
  ###
  gen: ->
    @routeGen.gen @docs.json, @overviews.getUrls()
    @dirTree.gen @docs.json
    @router.setRoute @routeGen.routes

  ###*
   * initialize state
   * @param  {Object} req request from express
   * @return {Object}     initialized state
  ###
  initialize: (req) ->
    initial_doc_data = {}
    initial_overview_markup = ""
    @router.route req.originalUrl, (route, argu) =>
      # console.log argu.route_arr
      switch argu.route_arr[0]
        when "class"
          file_id = argu.route_arr[2]?.toString()
          factor_id = argu.route_arr[3]?.toString()
          if file_id? && factor_id?
            initial_doc_data = @docs.getDocDataById file_id, factor_id
        when "overview"
          title_id = argu.route_arr[1] || 0
          initial_overview_markup = @overviews.getOverviewHtml(title_id)


    initialState =
      RouteStore:
        fragment: req.originalUrl
        root: config.router.root
        routes: @router.routes
      DocStore:
        dir_tree: @dirTree.dir_tree
        doc_data: initial_doc_data
      OverviewStore:
        markup: initial_overview_markup
        structure: @overviews.getTitleStructure()


    return initialState

module.exports = InitializeState
