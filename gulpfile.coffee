gulp = require 'gulp'
uglify = require 'gulp-uglify'
sourcemaps = require 'gulp-sourcemaps'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
reactify = require 'coffee-reactify'
gutil = require 'gulp-util'
plumber = require 'gulp-plumber'
rename = require 'gulp-rename'
gulpif = require 'gulp-if'
envify = require 'envify/custom'
mocha = require 'gulp-mocha'
watchify = require 'watchify'
browserify = require 'browserify'
formatter = require 'pretty-hrtime'
path = require 'path'
_ = require 'lodash'

others = [
]

env_production = false
gulp.task 'default', ['build']
gulp.task 'enable-build-production-mode', -> env_production = true
gulp.task 'build', ['enable-build-production-mode', 'build:others', 'browserify']
gulp.task 'build-dev', ['build:others', 'browserify']
gulp.task 'build:others', ("build:#{it.suffix}" for it in others)

watching = false
gulp.task 'enable-watch-mode', -> watching = true
gulp.task 'watch-prd', ['enable-build-production-mode', 'watch']
gulp.task 'watch', ['build:others', 'enable-watch-mode', 'browserify'], ->
  for it in others
    gulp.watch it.src, ["build:#{it.suffix}"]

config =
  server:
    entries: 'src/server.coffee'
    extensions: ['.coffee', '.js']
    transform: [
      'coffee-reactify'
      {name: 'envify', opt: {NODE_ENV: (if env_production then 'production' else 'development')}}
    ]
    name: 'app.js'
    dest: ''
    bundleExternal: false
    minify: false
    detectGlobals: false
  browser:
    entries: 'src/browser.coffee'
    extensions: ['.coffee', '.js']
    transform: [
      'coffee-reactify'
      {name: 'envify', opt: {NODE_ENV: (if env_production then 'production' else 'development')}}
    ]
    name: 'bundle.js'
    dest: 'public/js'
    bundleExternal: true
    minify: true
    detectGlobals: true

gulp.task "browserify", ("browserify:#{suffix}" for suffix of config)

###
bundling task
###

getBundler = (opt) ->
  if watching
    opt = _.merge opt, watchify.args
  b = browserify opt
  if watching
    b = watchify b, opt
  return b

Object.keys(config).forEach (suffix) ->
  c = config[suffix]
  gulp.task "browserify:#{suffix}", ->
    opt =
      entries: path.resolve(__dirname, c.entries)
      cache: {}
      packageCache: {}
      extensions: c.extensions
      debug: true
      detectGlobals: c.detectGlobals
      bundleExternal: c.bundleExternal
    b = getBundler opt
    c.transform.forEach (v) ->
      if _.isString v
        b = b.transform v
      else if _.isPlainObject v
        b = b.transform v.name, v.opt
    bundle = ->
      time = process.hrtime()
      gutil.log "Bundling #{suffix} #{if watching then '(watch mode)' else ''}"
      b
        .bundle()
        .on 'error', (err) ->
          gutil.log err.message
          @emit 'end'
        .on 'end', ->
          taskTime = formatter process.hrtime time
          gutil.log("Finished #{suffix} " + gutil.colors.magenta("#{taskTime}"))
        .pipe source c.name
        .pipe buffer()
        .pipe sourcemaps.init
          loadMaps: true
        .pipe gulpif(!watching && env_production, gulpif(c.minify, uglify()))
        .pipe sourcemaps.write('./')
        .pipe gulpif(!(!watching && env_production), sourcemaps.write('./'))
    if watching
      b.on 'update', bundle
    bundle()

gulp.task 'test', ->
  gulp
    .src './test/**/*test.coffee'
    .pipe mocha()
