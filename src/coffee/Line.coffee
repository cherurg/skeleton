d3 = require '../libs/d3/d3.js'
_ = require 'lodash'
colors = require './Colors.coffee'

class Line
  constructor: (linePure, graph, linearX, linearY, options) ->
    @pure = linePure
    _.extend @, Line.defaults, _.pick(options, _.keys Line.defaults)

    @draw graph, linearX, linearY

  draw: (graph, linearX, linearY) ->
    @el = graph
    .append 'line'
    .classed 'line', true
    .attr 'x1', linearX @pure.x1
    .attr 'x2', linearX @pure.x2
    .attr 'y1', linearY @pure.y1
    .attr 'y2', linearY @pure.y2
    .attr 'stroke', @color
    .attr 'stroke-width', @strokeWidth

  update: (linearX, linearY) ->
    #возможно
    [@linearX, @linearY] = [linearX, linearY]
    @el
    .attr 'x1', @linearX @pure.x1
    .attr 'x2', @linearX @pure.x2
    .attr 'y1', @linearY @pure.y1
    .attr 'y2', @linearY @pure.y2
    .attr 'stroke', @color
    .attr 'stroke-width', @strokeWidth

  clear: ->
    do @el.remove

  setX1: (x1) -> @pure.x1 = x1
  setX2: (x2) -> @pure.x2 = x2
  setY1: (y1) -> @pure.y1 = y1
  setY2: (y2) -> @pure.y2 = y2

Line.defaults =
  strokeWidth: 2
  color: colors(0)

module.exports = Line
