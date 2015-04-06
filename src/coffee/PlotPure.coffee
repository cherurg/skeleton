_ = require './utils.coffee'

class PlotPure
  defaults:
    left: -10
    right: 10
    bottom: -5
    top: 5

  constructor: (options) ->
    _.extendDefaults(@, options)

PlotPure.defaults =


module.exports = PlotPure