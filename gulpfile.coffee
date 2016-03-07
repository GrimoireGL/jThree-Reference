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
envify = require 'envify/custom'
mocha = require 'gulp-mocha'
fs = require 'fs'
path = require 'path'

others = [
]

env_production = false
gulp.task 'default', ['build']
gulp.task 'enable-build-production-mode', -> env_production = true
gulp.task 'build', ['enable-build-production-mode', 'build:others', 'browserify', 'bundle-example-files']
gulp.task 'build-dev', ['build:others', 'browserify', 'bundle-example-files']
gulp.task 'build:others', ("build:#{it.suffix}" for it in others)

watching = false
gulp.task 'enable-watch-mode', -> watching = true
gulp.task 'watch-prd', ['enable-build-production-mode', 'watch']
gulp.task 'watch', ['build:others', 'enable-watch-mode', 'browserify', 'bundle-example-files'], ->
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
          setup: (b) ->
            b.transform envify
              NODE_ENV: if env_production then 'production' else 'development'
        .pipe buffer()
        .pipe sourcemaps.init
          loadMaps: true
        .pipe gulpif(!watching && env_production, gulpif(it.minify, uglify()))
        .pipe rename(it.name)
        .pipe gulpif(!(!watching && env_production), sourcemaps.write('./'))
        .pipe gulp.dest(it.dest)

gulp.task 'test', ->
  gulp
    .src './test/**/*test.coffee'
    .pipe mocha()

gulp.task 'bundle-example-files', ->
  targetDir = "#{fs.realpathSync('./')}/clones/jThree-Example/markdowns"
  walk = (p, callback) ->
    results = []
    fs.readdir p, (err, files) ->
      if err
        throw err
      pending = files.length
      if !pending
        return callback(null, results)
      #全てのファイル取得が終わったらコールバックを呼び出す
      files.map((file) ->
        #リスト取得
        path.join p, file
      ).filter((file) ->
        if fs.statSync(file).isDirectory()
          walk file, (err, res) ->
            #ディレクトリだったら再帰
            results.push
              type: "directory"
              name: path.basename(file)
              children: res
            #子ディレクトリをchildrenインデックス配下に保存
            if !--pending
              callback null, results
            return
        fs.statSync(file).isFile()
      ).forEach (file) ->
        #ファイル名を保存
        # stat = fs.statSync(file)
        content = fs.readFileSync(file, "utf-8")
        fileName = (temp = path.basename(file).match(/(.*)(?:\.([^.]+$))/))[1]
        fileExtension = temp[2]
        if fileExtension == "md" || fileExtension == "markdown"
          results.push
            type: "file"
            file: fileName
            content: content
        if !--pending
          callback null, results
        return
      return
    return
  walk targetDir, (err, results) ->
    if err
      throw err
    data =
      type: "directory"
      name: 'markdowns'
      children: results
    outputTarget = "#{fs.realpathSync('./')}/src/server/example.json"
    fs.writeFile outputTarget, JSON.stringify(data, "", "  ")
    #一覧出力
    return
