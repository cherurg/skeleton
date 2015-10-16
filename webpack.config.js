module.exports = {
  entry: "./src/js/PlotContainer.js",
  output: {
    path: __dirname,
    filename: "dist/js/plot.js",
    library: 'sheckley',
    libraryTarget: 'umd'
  },
  module: {
    loaders: [
      { test: /\.coffee$/, exclude: /node_modules/, loader: "coffee-loader" },
      { test: /\.js$/, exclude: /node_modules/, loader: "babel-loader" }
    ]
  }
};