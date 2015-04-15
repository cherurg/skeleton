_ = require './utils.coffee'

class PlotPure
  defaults:
    left: -4
    right: 4
    bottom: -3
    top: 3

  constructor: (options) ->
    _.extendDefaults(@, options)


module.exports = PlotPure