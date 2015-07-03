gulp = require 'gulp'
uglify = require 'gulp-uglify'
sourcemaps = require 'gulp-sourcemaps'
buffer = require 'vinyl-buffer'
watchify = require 'gulp-watchify'
reactify = require 'coffee-reactify'
gutil = require 'gulp-util'
plumber = require 'gulp-plumber'
rename = require 'gulp-rename'
gulpif = require 'gulp-if'

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
gulp.task 'watch', ['build:others', 'enable-watch-mode', 'browserify'], ->
  for it in others
    gulp.watch it.src, ["build:#{it.suffix}"]

target = [
    suffix: 'server'
    src: 'src/server.coffee'
    name: 'app.js'
    dest: ''
    bundleExternal: false
    minify: false
    detectGlobals: false
  ,
    suffix: 'browser'
    src: 'src/browser.coffee'
    name: 'bundle.js'
    dest: 'public/js'
    bundleExternal: true
    minify: true
    detectGlobals: true
]

gulp.task "browserify", ("browserify:#{it.suffix}" for it in target)

target.forEach (it) ->
  gulp.task "browserify:#{it.suffix}", watchify (watchify) ->
    gulp
      .src it.src
        .pipe plumber()
        .pipe watchify
          watch: watching
          extensions: ['.coffee', '.js']
          debug: true
          transform: ['coffee-reactify']
          detectGlobals: it.detectGlobals
          bundleExternal: it.bundleExternal
        .pipe buffer()
        .pipe sourcemaps.init
          loadMaps: true
        .pipe gulpif(env_production, gulpif(it.minify, uglify()))
        .pipe rename(it.name)
        .pipe gulpif(!env_production, sourcemaps.write('./'))
        .pipe gulp.dest(it.dest)
