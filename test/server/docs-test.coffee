require '../spec-helper'

sample_json = require './mock-sample-json'

describe 'Server/Docs', ->
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
        comment:
          shortText: "sample comment"
        children:　[
            id: 3
            name: 'method1'
            kindString: 'Method'
            comment:
              shortText: "sample comment"
          ,
            id: 4
            name: 'prop1'
            kindString: 'Property'
            comment:
              shortText: "sample comment"
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
        comment:
          shortText: "sample comment"
        children:　[
            id: 3
            name: 'method1'
            kindString: 'Method'
            comment:
              shortText: "sample comment"
          ,
            id: 4
            name: 'prop1'
            kindString: 'Property'
            comment:
              shortText: "sample comment"
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
            comment:
              shortText: "sample comment"
            children:　[
                id: 3
                name: 'method1'
                kindString: 'Method'
                comment:
                  shortText: "sample comment"
              ,
                id: 4
                name: 'prop1'
                kindString: 'Property'
                comment:
                  shortText: "sample comment"
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
            comment:
              shortText: "sample comment"
            children:　[
                id: 3
                name: 'method1'
                kindString: 'Method'
                comment:
                  shortText: "sample comment"
              ,
                id: 4
                name: 'prop1'
                kindString: 'Property'
                comment:
                  shortText: "sample comment"
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
