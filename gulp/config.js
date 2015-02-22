var _ = require('lodash');

var dest = "./dist";
var src = './src';
var tests = './tests';

module.exports = {
  browserSync: {
    server: {
      // We're serving the src folder as well
      // for sass sourcemap linking
      baseDir: [dest, src]
    },
    files: [
      dest + "/**",
      // Exclude Map files
      "!" + dest + "/**.map"
    ]
  },
  sass: {
    src: src + "/sass/*.{sass, scss}",
    dest: dest
  },
  images: {
    src: src + "/images/**",
    dest: dest + "/images"
  },
  markup: {
    src: src + "/htdocs/**",
    dest: dest
  },
  coffee: {
    src: src + "/coffee/**"
  },
  browserify: {
    // Enable source maps
    debug: true,
    // Additional file extentions to make optional
    extensions: ['.coffee', '.hbs'],
    // A separate bundle will be generated for each
    // bundle config in the list below
    bundleConfigs: [{
      entries: src + '/coffee/PlotContainer.coffee',
      dest: dest + '/js',
      outputName: 'plot.js'
    }]
  },
  tests: {
    source: tests + "/*-test.*"
  },
  concat: {
    bundles: [{
      entries: [dest + "/js/plot.js"],
      name: "SkeletonWithControl.js",
      miniName: "SkeletonWithControl.min.js",
      dest: dest + "/js"
    }]
  },
  src: src,
  dest: dest
};
