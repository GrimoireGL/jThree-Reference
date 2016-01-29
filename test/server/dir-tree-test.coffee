require '../spec-helper'

sample_json = require './mock-sample-json'

describe 'Server/DirTree', ->
  describe 'constructDirTree', ->
    DirTree = null
    dirTree = null

    before ->
      DirTree = require_ '../src/server/stateInitializer/dir-tree'
      dirTree = new DirTree(sample_json)

    it 'should return object which has tree layered hash', ->
      correct =
        path: []
        dir:
          dir1:
            path: ['dir1']
            file:
              class1:
                name: 'class1'
                kindString: 'Class'
                path: ['dir1', 'class1']
                children: [
                    name: 'method1'
                    kindString: 'Method'
                  ,
                    name: 'prop1'
                    kindString: 'Property'
                ]
            dir:
              dir1_2:
                path: ['dir1', 'dir1_2']
                file:
                  class2:
                    name: 'class2'
                    kindString: 'Class'
                    path: ['dir1', 'dir1_2', 'class2']
                    children: [
                        name: 'constructor1'
                        kindString: 'Constructor'
                    ]
      result = dirTree.dir_tree
      expect(result).to.deep.equals(correct)
