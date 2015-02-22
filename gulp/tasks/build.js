var gulp = require('gulp');
var concat = require('gulp-concat');
var config = require('../config');

gulp.task('build', ['browserify', 'test'], function () {
    gulp.src([config.dest + "/js/plot.js", config.src + "/legacy/ControlSkeleton.js"])
        .pipe(concat('SkeletonWithControl.js'))
        .pipe(gulp.dest(config.dest + "/js/"));
});
