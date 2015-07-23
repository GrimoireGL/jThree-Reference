chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
fs = require 'fs'
clone = require 'lodash.clone'

chai.use sinonChai
expect = chai.expect

require_ = (target) ->
  delete require.cache[require.resolve target]
  return require target

describe 'server', ->
  sample_json =
    name: 'typedoc'
    children: [
        id: 1
        name: '"dir1/file1"'
        kindString: 'External modules'
        children: [
            id: 2
            name: 'class1'
            kindString: 'Class'
            children:　[
                id: 3
                name: 'method1'
                kindString: 'Method'
              ,
                id: 4
                name: 'prop1'
                kindString: 'Property'
            ]
            groups: [
                title: 'Methods'
                children: [3]
              ,
                title: 'Properties'
                children: [4]
            ]
        ]
        groups: [
            title: 'Classes'
            children: [2]
        ]
      ,
        id: 5
        name: '"dir1/dir1_2/file2"'
        kindString: 'External modules'
        children: [
            id: 6
            name: 'class2'
            kindString: 'Class'
            children: [
                id: 7
                name: 'constructor1'
                kindString: 'Constructor'
            ]
            groups: [
                title: 'Constructors'
                children: [7]
            ]
        ]
        groups: [
            title: 'Classes'
            children: [6]
        ]
    ]
    groups: [
        title: 'External modules'
        children: [1, 2]
    ]

  describe 'Docs', ->
    describe 'getGlobalClassById', ->
      doc_path = null
      Docs = null
      docs = null

      beforeEach ->
        Docs = require_ '../src/server/docs'
        docs = new Docs()
        docs.setJson sample_json

      it 'should return object if we try to get existed id with integer', ->
        file_id = 1
        factor_id = 2
        result = docs.getGlobalClassById(file_id, factor_id)
        correct =
          id: 2
          name: 'class1'
          kindString: 'Class'
          children:　[
              id: 3
              name: 'method1'
              kindString: 'Method'
            ,
              id: 4
              name: 'prop1'
              kindString: 'Property'
          ]
          groups: [
              title: 'Methods'
              children: [3]
            ,
              title: 'Properties'
              children: [4]
          ]
        expect(result).to.deep.equals(correct)

      it 'should return object if we try to get existed id with string', ->
        file_id = 1
        factor_id = 2
        result = docs.getGlobalClassById(file_id.toString(), factor_id.toString())
        correct =
          id: 2
          name: 'class1'
          kindString: 'Class'
          children:　[
              id: 3
              name: 'method1'
              kindString: 'Method'
            ,
              id: 4
              name: 'prop1'
              kindString: 'Property'
          ]
          groups: [
              title: 'Methods'
              children: [3]
            ,
              title: 'Properties'
              children: [4]
          ]
        expect(result).to.deep.equals(correct)

      it 'should return null if we try to get not existed id', ->
        result = docs.getGlobalClassById(100000, 100000)
        correct = null
        expect(result).to.deep.equals(correct)

    describe 'getGlobalFileById', ->
      doc_path = null
      Docs = null
      docs = null

      beforeEach ->
        Docs = require_ '../src/server/docs'
        docs = new Docs()
        docs.setJson sample_json

      it 'should return object if we try to get existed id with integer', ->
        file_id = 1
        result = docs.getGlobalFileById(file_id)
        correct =
          id: 1
          name: '"dir1/file1"'
          kindString: 'External modules'
        expect(result).to.deep.equals(correct)

      it 'should return object if we try to get existed id with string', ->
        file_id = 1
        result = docs.getGlobalFileById(file_id.toString())
        correct =
          id: 1
          name: '"dir1/file1"'
          kindString: 'External modules'
        expect(result).to.deep.equals(correct)

      it 'should return null if we try to get not existed id', ->
        result = docs.getGlobalFileById(100000)
        correct = null
        expect(result).to.deep.equals(correct)

    describe 'getDocDataById', ->
      doc_path = null
      Docs = null
      docs = null

      beforeEach ->
        Docs = require_ '../src/server/docs'
        docs = new Docs(doc_path)
        docs.setJson sample_json

      it 'should return object if we try to get existed id with integer', ->
        file_id = 1
        factor_id = 2
        result = docs.getDocDataById(file_id, factor_id)
        correct =
          '1':
            from:
              id: 1
              name: '"dir1/file1"'
              kindString: 'External modules'
            '2':
              id: 2
              name: 'class1'
              kindString: 'Class'
              children:　[
                  id: 3
                  name: 'method1'
                  kindString: 'Method'
                ,
                  id: 4
                  name: 'prop1'
                  kindString: 'Property'
              ]
              groups: [
                  title: 'Methods'
                  children: [3]
                ,
                  title: 'Properties'
                  children: [4]
              ]
        expect(result).to.deep.equals(correct)

      it 'should return object if we try to get existed id with string', ->
        file_id = 1
        factor_id = 2
        result = docs.getDocDataById(file_id.toString(), factor_id.toString())
        correct =
          '1':
            from:
              id: 1
              name: '"dir1/file1"'
              kindString: 'External modules'
            '2':
              id: 2
              name: 'class1'
              kindString: 'Class'
              children:　[
                  id: 3
                  name: 'method1'
                  kindString: 'Method'
                ,
                  id: 4
                  name: 'prop1'
                  kindString: 'Property'
              ]
              groups: [
                  title: 'Methods'
                  children: [3]
                ,
                  title: 'Properties'
                  children: [4]
              ]
        expect(result).to.deep.equals(correct)

      it 'should return empty object if we try to get not existed id', ->
        correct = {}
        result = docs.getDocDataById(100000, 100000)
        expect(result).to.deep.equals(correct)

  describe 'DirTree', ->
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
