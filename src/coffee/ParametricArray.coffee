_ = require 'lodash'
d3 = require '../libs/d3/d3.js'
colors = require './Colors.coffee'

class ParametricArray
  constructor: (parametricArrayPure, graph, linearX, linearY, options) ->
    @pure = parametricArrayPure
    _.extend @, ParametricArray.defaults, _.pick(options, _.keys ParametricArray.defaults)

    @draw graph, linearX, linearY

  draw: (graph, linearX, linearY) ->
    self = @
    @path = d3.svg.line()
    .x (d) -> self.linearX d.x
    .y (d) -> self.linearY d.y

    @g = graph
    .append 'g'

    @el = @g
    .append 'path'
    .classed 'Parametric', true
    .attr 'fill', @fill
    .attr 'fill-opacity', @fillOpacity
    .attr 'stroke-width', @strokeWidth
    .attr 'stroke', @color

    @update linearX, linearY

  update: (linearX, linearY) ->
    [@linearX, @linearY] = [linearX, linearY]

    @el.attr 'd', @path @pure.array

  clear: -> @el.remove()

ParametricArray.defaults =
  color: colors(20)
  fillOpacity: 0.2
  strokeWidth: 0
  fill: colors(1)

module.exports = ParametricArray