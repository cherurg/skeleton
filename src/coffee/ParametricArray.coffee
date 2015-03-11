_ = require 'lodash'
d3 = require '../libs/d3/d3.js'
Colors = require('./Colors.coffee')('Color')
Colours = require('./Colors.coffee')('Colour', 'color')
Fill = require('./Colors.coffee')('Fill')

class ParametricArray
  _.extend(@::, Colors::, Colours::, Fill::)

  constructor: (parametricArrayPure, graph, linearX, linearY, options = {}) ->
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

    [@linearX, @linearY] = [linearX, linearY] if linearX? and linearY?
    @update()

  update: () ->
    @el.attr 'd', @path @pure.array
    .attr 'fill', @Fill()
    .attr 'fill-opacity', @fillOpacity
    .attr 'stroke-width', @strokeWidth
    .attr 'stroke', @Color()

  clear: -> @el.remove()

  setFillOpacity: (opacity) -> @fillOpacity = opacity
  getFillOpacity: -> @fillOpacity
  Opacity: (opacity) -> if opacity? then @setFillOpacity(opacity) else @getFillOpacity()

  setStrokeWidth: (strokeWidth) -> @strokeWidth = strokeWidth
  getStrokeWidth: -> @strokeWidth
  StrokeWidth: (strokeWidth) -> if strokeWidth? then @setStrokeWidth(strokeWidth) else @getStrokeWidth()

ParametricArray.defaults =
  color: 20
  fillOpacity: 0.2
  strokeWidth: 0
  fill: 1

module.exports = ParametricArray