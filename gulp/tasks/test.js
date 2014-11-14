//var gulp = require('gulp');
//var mocha = require('gulp-mocha');
//var yargs = require('yargs');
//var config = require('../config').tests;
//
//function handleError(err) {
//  console.error(err.message);
//  process.exit(1);
//}
//
//gulp.task('test', function () {
//  gulp.src(config.source, {read: false})
//      .pipe(mocha({reporter: 'spec', grep: yargs.argv.grep, require: 'coffee-script/register'}))
//      .on('error', handleError);
//});

require('coffee-script/register');
require('./test.coffee');