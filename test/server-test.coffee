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
  describe 'Docs', ->
    describe 'getGlobalClassById', ->
      doc_path = null
      Docs = null
      docs = null

      before ->
        doc_path = "#{fs.realpathSync('./')}/src/server/doc.json"

      beforeEach (done) ->
        Docs = require_ '../src/server/docs'
        docs = new Docs(doc_path)
        docs.getLocalJson -> done()

      it 'should return object if we try to get existed id with integer', ->
        current = JSON.parse(fs.readFileSync("#{fs.realpathSync('./')}/src/server/doc.json")).children[0]
        file_id = current.id
        factor_id = current.children[0].id
        result = docs.getGlobalClassById(file_id, factor_id)
        expect(result).to.deep.equals(current.children[0])

      it 'should return object if we try to get existed id with string', ->
        current = JSON.parse(fs.readFileSync("#{fs.realpathSync('./')}/src/server/doc.json")).children[0]
        file_id = current.id
        factor_id = current.children[0].id
        result = docs.getGlobalClassById(file_id.toString(), factor_id.toString())
        expect(result).to.deep.equals(current.children[0])

      it 'should return null if we try to get not existed id', ->
        correct = null
        result = docs.getGlobalClassById(100000, 100000)
        expect(result).to.deep.equals(correct)

    describe 'getGlobalFileById', ->
      doc_path = null
      Docs = null
      docs = null

      before ->
        doc_path = "#{fs.realpathSync('./')}/src/server/doc.json"

      beforeEach (done) ->
        Docs = require_ '../src/server/docs'
        docs = new Docs(doc_path)
        docs.getLocalJson -> done()

      it 'should return object if we try to get existed id with integer', ->
        current = JSON.parse(fs.readFileSync("#{fs.realpathSync('./')}/src/server/doc.json")).children[0]
        file_id = current.id
        result = docs.getGlobalFileById(file_id)
        delete current.children
        delete current.groups
        expect(result).to.deep.equals(current)

      it 'should return object if we try to get existed id with string', ->
        current = JSON.parse(fs.readFileSync("#{fs.realpathSync('./')}/src/server/doc.json")).children[0]
        file_id = current.id
        result = docs.getGlobalFileById(file_id.toString())
        delete current.children
        delete current.groups
        expect(result).to.deep.equals(current)

      it 'should return null if we try to get not existed id', ->
        correct = null
        result = docs.getGlobalFileById(100000)
        expect(result).to.deep.equals(correct)

    describe 'getDocDataById', ->
      doc_path = null
      Docs = null
      docs = null

      before ->
        doc_path = "#{fs.realpathSync('./')}/src/server/doc.json"

      beforeEach (done) ->
        Docs = require_ '../src/server/docs'
        docs = new Docs(doc_path)
        docs.getLocalJson -> done()

      it 'should return object if we try to get existed id with integer', ->
        current = JSON.parse(fs.readFileSync("#{fs.realpathSync('./')}/src/server/doc.json")).children[0]
        file_id = current.id
        factor_id = current.children[0].id
        result = docs.getDocDataById(file_id, factor_id)
        correct = {}
        correct[file_id] = {}
        from = clone current, true
        delete from.children
        delete from.groups
        correct[file_id].from = from
        correct[file_id][factor_id] = current.children[0]
        expect(result).to.deep.equals(correct)

      it 'should return object if we try to get existed id with string', ->
        current = JSON.parse(fs.readFileSync("#{fs.realpathSync('./')}/src/server/doc.json")).children[0]
        file_id = current.id
        factor_id = current.children[0].id
        result = docs.getDocDataById(file_id.toString(), factor_id.toString())
        correct = {}
        correct[file_id] = {}
        from = clone current, true
        delete from.children
        delete from.groups
        correct[file_id].from = from
        correct[file_id][factor_id] = current.children[0]
        expect(result).to.deep.equals(correct)

      it 'should return empty object if we try to get not existed id', ->
        correct = {}
        result = docs.getDocDataById(100000, 100000)
        expect(result).to.deep.equals(correct)

  describe 'DirTree', ->
    describe 'constructDirTree', ->
      DirTree = null
      dirTree = null
      sample_json = null

      before ->
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
        DirTree = require_ '../src/server/stateInitializer/dir-tree'
        dirTree = new DirTree(sample_json)

      it 'should return object', ->
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
