d3 = require '../libs/d3/d3.js'
_ = require 'lodash'
Colors = require('./Colors.coffee')('Color')
Colours = require('./Colors.coffee')('Colour', 'color')
LinePure = require('./LinePure.coffee')

class Line
  _.extend(@::, Colors::, Colours::)

  defaults:
    strokeWidth: 2
    color: 0

  constructor: (linePure, graph, linearX, linearY, options = {}) ->
    if linePure.model is 'Line'
      @setModel(linePure, silent: true)
    else
      @pure = linePure
      _.extend @, @defaults, _.pick(options, _.keys @defaults)

    @draw graph, linearX, linearY

  draw: (graph, linearX, linearY) ->
    @el = graph
    .append 'line'
    .classed 'line', true

    [@linearX, @linearY] = [linearX, linearY] if linearX? and linearY?

    @update()

  update: () ->
    @el
    .attr 'x1', @linearX @pure.x1
    .attr 'x2', @linearX @pure.x2
    .attr 'y1', @linearY @pure.y1
    .attr 'y2', @linearY @pure.y2
    .attr 'stroke', @Color()
    .attr 'stroke-width', @strokeWidth

  clear: ->
    do @el.remove

  setX1: (x1) -> @pure.x1 = x1
  getX1: -> @pure.x1
  X1: (x1) -> if x1? then @setX1(x1) else @getX1()

  setX2: (x2) -> @pure.x2 = x2
  getX2: -> @pure.x2
  X2: (x2) -> if x2? then @setX2(x2) else @getX2()

  setY1: (y1) -> @pure.y1 = y1
  getY1: -> @pure.y1
  Y1: (y1) -> if y1? then @setY1(y1) else @getY1()

  setY2: (y2) -> @pure.y2 = y2
  getY2: -> @pure.y2
  Y2: (y2) -> if y2? then @setY2(y2) else @getY2()

  getModel: ->
    properties = _.pick(@, _.keys(@defaults))
    properties = _.extend(properties, _.pick(@pure, _.keys(@pure.defaults)))
    properties.coordinates = @pure.getCoordinates()
    properties.model = 'Line'
    properties

  setModel: (model, options = {}) ->
    _.extendDefaults(@, model)
    @pure = new LinePure() unless @pure?
    _.extendDefaults(@pure, model)
    @pure.setCoordinates(model.coordinates)
    unless options.silent
      @update()

module.exports = Line
