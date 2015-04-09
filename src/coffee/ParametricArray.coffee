_ = require './utils.coffee'
d3 = require '../libs/d3/d3.js'
Colors = require('./Colors.coffee')('Color')
Colours = require('./Colors.coffee')('Colour', 'color')
Fill = require('./Colors.coffee')('Fill')

class ParametricArray
  defaults:
    color: 20
    fillOpacity: 0.2
    strokeWidth: 0
    fill: 1

  _.extend(@::, Colors::, Colours::, Fill::)

  constructor: (parametricArrayPure, graph, linearX, linearY, options = {}) ->

    if parametricArrayPure.model is 'ParametricArray'
      @setModel(parametricArrayPure)
    else
      @pure = parametricArrayPure
      _.extend @, @defaults, _.pick(options, _.keys @defaults)

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

  getModel: ->
    properties = _.pick(@, _.keys(@defaults))
    properties = _.extend(properties, _.pick(@pure, _.keys(@pure.defaults)))
    properties.array = @pure.array
    properties.model = 'ParametricArray'
    properties

  setModel: (model) ->
    _.extendDefaults(@, model)
    _.extendDefaults(@pure, model)
    @pure.array = model.array
    @update()

module.exports = ParametricArray