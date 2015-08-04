require '../spec-helper'

describe 'Client/Router', ->
  describe 'setRoot', ->
    Router = null
    router = null

    before ->
      Router = require_ '../src/renderer/lib/router'

    beforeEach ->
      router = new Router()

    it '@root should be "/" when "/" is given', ->
      router.setRoot '/'
      result = router.root
      correct = '/'
      expect(result).to.deep.equals(correct)

    it '@root should be "/test/" when "test" is given', ->
      router.setRoot 'test'
      result = router.root
      correct = '/test/'
      expect(result).to.deep.equals(correct)

    it '@root should be "/test/" when "/test" is given', ->
      router.setRoot '/test'
      result = router.root
      correct = '/test/'
      expect(result).to.deep.equals(correct)

    it '@root should be "/test/" when "test/" is given', ->
      router.setRoot 'test/'
      result = router.root
      correct = '/test/'
      expect(result).to.deep.equals(correct)

    it '@root should be "/test/" when "/test/" is given', ->
      router.setRoot '/test/'
      result = router.root
      correct = '/test/'
      expect(result).to.deep.equals(correct)

  describe 'setRoute', ->
    Router = null
    router = null

    before ->
      Router = require_ '../src/renderer/lib/router'

    beforeEach ->
      router = new Router()

    it '@route should be object when object is given', ->
      router.setRoute
        'hello/world' : 'index'
      result = router.routes
      correct =
        'hello/world' : 'index'
      expect(result).to.deep.equals(correct)

    it '@route object should be replaced when object is given', ->
      router.setRoute
        'hello/world' : 'index'
      router.setRoute
        'bye/world' : 'end'
      result = router.routes
      correct =
        'bye/world' : 'end'
      expect(result).to.deep.equals(correct)

    it '@route should not be changed when no arguments are given', ->
      router.setRoute()
      result = router.routes
      correct = {}
      expect(result).to.deep.equals(correct)

  describe 'addRoute', ->
    Router = null
    router = null

    before ->
      Router = require_ '../src/renderer/lib/router'

    beforeEach ->
      router = new Router()

    it '@route should be object when path and route are given', ->
      router.addRoute 'hello/world', 'index'
      result = router.routes
      correct =
        'hello/world' : 'index'
      expect(result).to.deep.equals(correct)

    it '@route should be object when path and route are given (multiple)', ->
      router.addRoute 'hello/world', 'index'
      router.addRoute 'hello/heaven', 'special'
      result = router.routes
      correct =
        'hello/world' : 'index'
        'hello/heaven' : 'special'
      expect(result).to.deep.equals(correct)

    it '@route should be object when object is given', ->
      router.addRoute
        'hello/world' : 'index'
      result = router.routes
      correct =
        'hello/world' : 'index'
      expect(result).to.deep.equals(correct)

    it '@route should be object when object is given (multiple)', ->
      router.addRoute
        'hello/world' : 'index'
      router.addRoute
        'hello/heaven' : 'special'
      result = router.routes
      correct =
        'hello/world' : 'index'
        'hello/heaven' : 'special'
      expect(result).to.deep.equals(correct)

    it '@route should be object when object is given (multiple, once)', ->
      router.addRoute
        'hello/world' : 'index'
        'hello/heaven' : 'special'
      result = router.routes
      correct =
        'hello/world' : 'index'
        'hello/heaven' : 'special'
      expect(result).to.deep.equals(correct)

    it '@route object should be overwrited when object which has existed path is given', ->
      router.addRoute
        'hello/world' : 'index'
      router.addRoute
        'hello/world' : 'overwrited'
      result = router.routes
      correct =
        'hello/world' : 'overwrited'
      expect(result).to.deep.equals(correct)

    it '@route should not be changed when no arguments are given', ->
      router.addRoute()
      result = router.routes
      correct = {}
      expect(result).to.deep.equals(correct)

  describe 'setAuth', ->
    Router = null
    router = null

    before ->
      Router = require_ '../src/renderer/lib/router'

    beforeEach ->
      router = new Router()

    it '@auth should be object when route, required and renavigate is given', ->
      router.setAuth 'index', true, 'login'
      result = router.auth
      correct =
        'index' :
          required: true
          renavigate: 'login'
      expect(result).to.deep.equals(correct)

    it '@auth should be object when route, required and renavigate is given (multiple)', ->
      router.setAuth 'index', true, 'login'
      router.setAuth 'login', false, 'index'
      result = router.auth
      correct =
        'index' :
          required: true
          renavigate: 'login'
        'login' :
          required: false
          renavigate: 'index'
      expect(result).to.deep.equals(correct)

    it '@auth should be object when object is given', ->
      router.setAuth
        'index' :
          required: true
          renavigate: 'login'
      result = router.auth
      correct =
        'index' :
          required: true
          renavigate: 'login'
      expect(result).to.deep.equals(correct)

    it '@auth should be object when object is given (multiple)', ->
      router.setAuth
        'index' :
          required: true
          renavigate: 'login'
      router.setAuth
        'login' :
          required: false
          renavigate: 'index'
      result = router.auth
      correct =
        'index' :
          required: true
          renavigate: 'login'
        'login' :
          required: false
          renavigate: 'index'
      expect(result).to.deep.equals(correct)

    it '@auth object should be overwrited when object which has existed route is given', ->
      router.setAuth
        'index' :
          required: true
          renavigate: 'login'
      router.setAuth
        'index' :
          required: false
          renavigate: 'overwrited'
      result = router.auth
      correct =
        'index' :
          required: false
          renavigate: 'overwrited'
      expect(result).to.deep.equals(correct)

    it '@auth should not be changed when no arguments are given', ->
      router.setAuth()
      result = router.auth
      correct = {}
      expect(result).to.deep.equals(correct)

  describe 'route', ->
    Router = null
    router = null
    sample_routes = {}
    sample_auth = {}

    before ->
      Router = require_ '../src/renderer/lib/router'
      sample_routes =
        '' : 'index'
        'about' : 'about'
        'about/name' : 'about:name'
        'about/contact' : 'about:contact'
        'login' : 'login'
        'page' : 'page'
        'page/([0-9]+)' : 'page:overview'
        'page/([0-9]+)/detail' : 'page:detail'
        'page/([0-9]+)/comment' : 'page:comment'
      sample_auth =
        'login' :
          required: false
          renavigate: ''
        'page' :
          required: true
          renavigate: 'login'

    beforeEach ->
      router = new Router()
      router.setRoot '/'
      router.setRoute sample_routes
      router.setAuth sample_auth

    it 'should be call callback with "index" route when "/" fragment is given (not using login argument)', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/', resolve, reject
      correct_route = 'index'
      correct_argu =
        route: 'index'
        route_arr: ['index']
        fragment: ''
        fragment_arr: ['']
        match: []
      correct_default_route = null
      correct_fragment = ''
      correct_default_fragment = null
      expect(resolve).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
      expect(reject).to.have.not.been.called

    it 'should be call callback with "index" route when "/" fragment is given (logined)', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/', true, resolve, reject
      correct_route = 'index'
      correct_argu =
        route: 'index'
        route_arr: ['index']
        fragment: ''
        fragment_arr: ['']
        match: []
      correct_default_route = null
      correct_fragment = ''
      correct_default_fragment = null
      expect(resolve).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
      expect(reject).to.have.not.been.called

    it 'should be call callback with "index" route when "/" fragment is given (not logined)', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/', false, resolve, reject
      correct_route = 'index'
      correct_argu =
        route: 'index'
        route_arr: ['index']
        fragment: ''
        fragment_arr: ['']
        match: []
      correct_default_route = null
      correct_fragment = ''
      correct_default_fragment = null
      expect(resolve).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
      expect(reject).to.have.not.been.called

    it 'should be call callback with "about" route when "/about" fragment is given', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/about', resolve, reject
      correct_route = 'about'
      correct_argu =
        route: 'about'
        route_arr: ['about']
        fragment: 'about'
        fragment_arr: ['about']
        match: []
      correct_default_route = null
      correct_fragment = 'about'
      correct_default_fragment = null
      expect(resolve).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
      expect(reject).to.have.not.been.called

    it 'should be call callback with "about:name" route when "/about/name" fragment is given', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/about/name', resolve, reject
      correct_route = 'about:name'
      correct_argu =
        route: 'about:name'
        route_arr: ['about', 'name']
        fragment: 'about/name'
        fragment_arr: ['about', 'name']
        match: []
      correct_default_route = null
      correct_fragment = 'about/name'
      correct_default_fragment = null
      expect(resolve).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
      expect(reject).to.have.not.been.called

    it 'should be call callback with "about:contact" route when "/about/contact" fragment is given', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/about/contact', resolve, reject
      correct_route = 'about:contact'
      correct_argu =
        route: 'about:contact'
        route_arr: ['about', 'contact']
        fragment: 'about/contact'
        fragment_arr: ['about', 'contact']
        match: []
      correct_default_route = null
      correct_fragment = 'about/contact'
      correct_default_fragment = null
      expect(resolve).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
      expect(reject).to.have.not.been.called

    it 'should be call callback with "login" route when "/page" fragment is given (not logined)', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/page', false, resolve, reject
      correct_route = 'login'
      correct_argu =
        route: 'login'
        route_arr: ['login']
        fragment: 'login'
        fragment_arr: ['login']
        match: []
      correct_default_route = 'page'
      correct_fragment = 'login'
      correct_default_fragment = 'page'
      expect(resolve).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
      expect(reject).to.have.not.been.called

    it 'should be call callback with "page" route when "/page" fragment is given (logined)', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/page', true, resolve, reject
      correct_route = 'page'
      correct_argu =
        route: 'page'
        route_arr: ['page']
        fragment: 'page'
        fragment_arr: ['page']
        match: []
      correct_default_route = null
      correct_fragment = 'page'
      correct_default_fragment = null
      expect(resolve).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
      expect(reject).to.have.not.been.called

    it 'should be call callback with "login" route when "/page/1234" fragment is given (not logined)', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/page/1234', false, resolve, reject
      correct_route = 'login'
      correct_argu =
        route: 'login'
        route_arr: ['login']
        fragment: 'login'
        fragment_arr: ['login']
        match: []
      correct_default_route = 'page:overview'
      correct_fragment = 'login'
      correct_default_fragment = 'page/1234'
      expect(resolve).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
      expect(reject).to.have.not.been.called

    it 'should be call callback with "page:overview" route when "/page/1234" fragment is given (logined)', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/page/1234', true, resolve, reject
      correct_route = 'page:overview'
      correct_argu =
        route: 'page:overview'
        route_arr: ['page', 'overview']
        fragment: 'page/1234'
        fragment_arr: ['page', '1234']
        match: ['1234']
      correct_default_route = null
      correct_fragment = 'page/1234'
      correct_default_fragment = null
      expect(resolve).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
      expect(reject).to.have.not.been.called

    it 'should be call callback with "login" route when "/page/1234/detail" fragment is given (not logined)', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/page/1234/detail', false, resolve, reject
      correct_route = 'login'
      correct_argu =
        route: 'login'
        route_arr: ['login']
        fragment: 'login'
        fragment_arr: ['login']
        match: []
      correct_default_route = 'page:detail'
      correct_fragment = 'login'
      correct_default_fragment = 'page/1234/detail'
      expect(resolve).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
      expect(reject).to.have.not.been.called

    it 'should be call callback with "page:detail" route when "/page/1234/detail" fragment is given (logined)', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/page/1234/detail', true, resolve, reject
      correct_route = 'page:detail'
      correct_argu =
        route: 'page:detail'
        route_arr: ['page', 'detail']
        fragment: 'page/1234/detail'
        fragment_arr: ['page', '1234', 'detail']
        match: ['1234']
      correct_default_route = null
      correct_fragment = 'page/1234/detail'
      correct_default_fragment = null
      expect(resolve).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
      expect(reject).to.have.not.been.called

    it 'should be call callback with "login" route when "/page/1234/comment" fragment is given (not logined)', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/page/1234/comment', false, resolve, reject
      correct_route = 'login'
      correct_argu =
        route: 'login'
        route_arr: ['login']
        fragment: 'login'
        fragment_arr: ['login']
        match: []
      correct_default_route = 'page:comment'
      correct_fragment = 'login'
      correct_default_fragment = 'page/1234/comment'
      expect(resolve).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
      expect(reject).to.have.not.been.called

    it 'should be call callback with "page:comment" route when "/page/1234/comment" fragment is given (logined)', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/page/1234/comment', true, resolve, reject
      correct_route = 'page:comment'
      correct_argu =
        route: 'page:comment'
        route_arr: ['page', 'comment']
        fragment: 'page/1234/comment'
        fragment_arr: ['page', '1234', 'comment']
        match: ['1234']
      correct_default_route = null
      correct_fragment = 'page/1234/comment'
      correct_default_fragment = null
      expect(resolve).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
      expect(reject).to.have.not.been.called

    it 'should be call callback with "login" route when "/login" fragment is given (not logined)', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/login', false, resolve, reject
      correct_route = 'login'
      correct_argu =
        route: 'login'
        route_arr: ['login']
        fragment: 'login'
        fragment_arr: ['login']
        match: []
      correct_default_route = null
      correct_fragment = 'login'
      correct_default_fragment = null
      expect(resolve).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
      expect(reject).to.have.not.been.called

    it 'should be call callback with "index" route when "/login" fragment is given (logined)', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/login', true, resolve, reject
      correct_route = 'index'
      correct_argu =
        route: 'index'
        route_arr: ['index']
        fragment: ''
        fragment_arr: ['']
        match: []
      correct_default_route = 'login'
      correct_fragment = ''
      correct_default_fragment = 'login'
      expect(resolve).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
      expect(reject).to.have.not.been.called

    it 'should be call reject callback when not existed fragment is given', ->
      resolve = sinon.spy()
      reject = sinon.spy()
      router.route '/not_exist_path', true, resolve, reject
      correct_route = null
      correct_argu = []
      correct_default_route = null
      correct_fragment = 'not_exist_path'
      correct_default_fragment = null
      expect(resolve).to.have.not.been.called
      expect(reject).to.have.been.calledWith(correct_route, correct_argu, correct_default_route, correct_fragment, correct_default_fragment)
