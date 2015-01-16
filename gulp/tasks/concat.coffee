gulp = require 'gulp'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
gulpif = require 'gulp-if'
config = require('../config').concat

#если аргумент true, то еще будет и минификация
smash = (mini) ->
  for b in config.bundles
    console.log b
    gulp.src(b.entries)
      .pipe(gulpif mini, concat(b.miniName), concat(b.name))
      .pipe(gulpif mini, uglify())
      .pipe(gulp.dest(b.dest))

gulp.task 'concat', ['browserify'], -> smash(false)

gulp.task 'concat-minify', ['browserify'], -> smash(true)