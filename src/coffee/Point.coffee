d3 = require '../libs/d3/d3.js'
_ = require 'lodash'

class Point
  constructor: (pointPure, graph, options) ->
    @pure = pointPure
    _.extend(@, @defaults, options)

  # аргументы принадлежат типу d3.linear
  draw: (x, y) ->


  defaults: {}

module.exports = Point