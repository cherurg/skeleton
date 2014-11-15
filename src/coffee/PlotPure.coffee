_ = require 'lodash'

class PlotPure
  constructor: (options) ->
    _.extend @, PlotPure.defaults, options

PlotPure.defaults =
  left: -10
  right: 10
  bottom: -5
  top: 5

module.exports = PlotPure