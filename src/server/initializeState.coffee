RoutesGen = require './stateInitializer/routes-gen'
config = require './stateInitializer/initializeStateConfig'
DirTree = require './stateInitializer/dir-tree'
DocCoverage = require './stateInitializer/doc-coverage'
Docs = require './docs'
Router = require '../renderer/lib/router'
readExample = require './stateInitializer/read-example'
Examples = require './examples'

class InitializeState
  ###*
   * initialize state for stores in client
   * @return {InitializeState}
  ###
  constructor: (docs) ->
    @docs = docs
    @routeGen = new RoutesGen()
    @dirTree = new DirTree()
    @doc_coverage = new DocCoverage()
    @router = new Router(config.router.root, @routeGen.routes)
    @examples = new Examples()

  ###*
   * resetup state initializer
  ###
  gen: ->
    # console.log @examples.getTitleArray()
    @routeGen.gen @docs.json, @examples.routes
    @dirTree.gen @docs.json
    @doc_coverage.gen @docs.json
    @router.setRoute @routeGen.routes

  ###*
   * initialize state
   * @param  {Object} req request from express
   * @return {Object}     initialized state
  ###
  initialize: (req) ->
    initial_doc_data = {}
    initial_example_markup = ""
    initial_example_structure = []
    @router.route req.originalUrl, (route, argu) =>
      # console.log argu.route_arr
      switch argu.route_arr[0]
        when "class"
          file_id = argu.route_arr[2]?.toString()
          factor_id = argu.route_arr[3]?.toString()
          if file_id? && factor_id?
            initial_doc_data = @docs.getDocDataById file_id, factor_id
        when "example"
          title_id = argu.route_arr[1] || 0
          initial_example_markup = {}
          initial_example_structure = @examples.structure


    initialState =
      RouteStore:
        fragment: req.originalUrl
        root: config.router.root
        routes: @router.routes
      DocStore:
        dir_tree: @dirTree.dir_tree
        doc_data: initial_doc_data
      ExampleStore:
        markup: initial_example_markup
        structure: initial_example_structure
      DocCoverageStore:
        coverage: @doc_coverage.coverage


    return initialState

module.exports = InitializeState
