require '../spec-helper'

sample_json = require './mock-sample-json'

describe 'Server/DocCoverage', ->
  describe 'calcurateCoverage', ->
    DocCoverage = null
    docCoverage = null

    before ->
      DocCoverage = require_ '../src/server/stateInitializer/doc-coverage'
      docCoverage = new DocCoverage(sample_json)

    it 'should return object which has tree layered hash', ->
      correct = {
        "all": 5,
        "covered": 5,
        "children": [
          {
            "name": "\"dir1/file1\"",
            "children": [
              {
                "name": "class1",
                "children": [
                  {
                    "name": "method1",
                    "all": 1,
                    "covered": 1
                  },
                  {
                    "name": "prop1",
                    "all": 1,
                    "covered": 1
                  }
                ],
                "all": 3,
                "covered": 3
              }
            ],
            "all": 3,
            "covered": 3
          },
          {
            "name": "\"dir1/dir1_2/file2\"",
            "children": [
              {
                "name": "class2",
                "children": [
                  {
                    "name": "constructor1",
                    "all": 1,
                    "covered": 1
                  }
                ],
                "all": 2,
                "covered": 2
              }
            ],
            "all": 2,
            "covered": 2
          }
        ]
      }
      result = docCoverage.coverage
      expect(result).to.deep.equals(correct)
