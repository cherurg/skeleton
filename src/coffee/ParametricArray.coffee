_ = require 'lodash'
d3 = require '../libs/d3/d3.js'
colors = require './Colors.coffee'

class ParametricArray
  constructor: (parametricArrayPure, graph, linearX, linearY, options = {}) ->
    @pure = parametricArrayPure
    _.extend @, ParametricArray.defaults, _.pick(options, _.keys ParametricArray.defaults)

    @Color(options.color) if options.color
    @Fill(options.fill) if options.fill

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

    @update linearX, linearY

  update: (linearX, linearY) ->
    [@linearX, @linearY] = [linearX, linearY] if linearX? and linearY?

    @el.attr 'd', @path @pure.array
    .attr 'fill', @fill
    .attr 'fill-opacity', @fillOpacity
    .attr 'stroke-width', @strokeWidth
    .attr 'stroke', @color

  clear: -> @el.remove()

  getColor: -> @color
  getColour: -> @getColor()
  setColor: (color) ->
    @color = colors(color) if _.isNumber(color)
    @color = color if _.isString(color) and color[0] is "#"
    @update() if @el?
    @color
  setColour: (colour) -> @setColor(colour)
  Color: (color) -> if color? then @setColor(color) else @getColor()
  Colour: (colour) -> @Color(colour)

  setFillOpacity: (opacity) -> @fillOpacity = opacity
  getFillOpacity: -> @fillOpacity
  Opacity: (opacity) -> if opacity? then @setFillOpacity(opacity) else @getFillOpacity()

  setStrokeWidth: (strokeWidth) -> @strokeWidth = strokeWidth
  getStrokeWidth: -> @strokeWidth
  StrokeWidth: (strokeWidth) -> if strokeWidth? then @setStrokeWidth(strokeWidth) else @getStrokeWidth()

  getFill: -> @fill
  setFill: (fill) ->
    @fill = colors(fill) if _.isNumber(fill)
    @fill = color if _.isString(fill) and fill[0] is "#"
    @update() if @el?
    @fill
  Fill: (fill) -> if fill? then @setFill(fill) else @getFill()

ParametricArray.defaults =
  color: colors(20)
  fillOpacity: 0.2
  strokeWidth: 0
  fill: colors(1)

module.exports = ParametricArray