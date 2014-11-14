gulp = require 'gulp'
mocha = require 'gulp-mocha'
yargs = require 'yargs'
config = require('../config').tests
watch = require 'gulp-watch'

handleError = (err) ->
  console.error err.message
  process.exit 1

gulp.task 'test', ->
  gulp.src(config.source, read: false)
  .pipe(mocha(reporter: 'spec', grep: yargs.argv.grep))
  .on 'error', handleError

###gulp.task 'test', ->
  path = '/src/coffee/*.coffee'

  gulp.src path
  .pipe watch path, (files) ->
    files.pipe mocha reporter: 'spec', grep: yargs.argv.grep
    .on 'error', handleError###
