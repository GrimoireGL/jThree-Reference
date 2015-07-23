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
