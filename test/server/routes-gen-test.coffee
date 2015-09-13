require '../spec-helper'
_ = require 'lodash'

sample_json = require './mock-sample-json'

describe 'Server/RoutesGen', ->
  describe 'constructRoutes', ->
    RoutesGen = null
    routesGen = null

    before ->
      RoutesGen = require_ '../src/server/stateInitializer/routes-gen'
      routesGen = new RoutesGen(sample_json)

    it 'should return object which has pair of path and route under class/', ->
      correct =
        'class' : 'class'
        'class/dir1' : 'class:global'
        'class/dir1/class1': 'class:global:1:2'
        'class/dir1/class1/method1': 'class:local:1:2:3'
        'class/dir1/class1/prop1': 'class:local:1:2:4'
        'class/dir1/dir1_2' : 'class:global'
        'class/dir1/dir1_2/class2': 'class:global:5:6'
        'class/dir1/dir1_2/class2/constructor1': 'class:local:5:6:7'
      result = _(routesGen.routes)
        .mapValues (v) ->
          if /^class(\:|$)/.test(v) then v else null
        .omit _.isNull
        .value()
      expect(result).to.deep.equals(correct)
