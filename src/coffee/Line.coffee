d3 = require '../libs/d3/d3.js'
_ = require 'lodash'
colors = require './Colors.coffee'

class Line
  constructor: (linePure, graph, linearX, linearY, options = {}) ->
    @pure = linePure
    _.extend @, Line.defaults, _.pick(options, _.keys Line.defaults)

    @color = colors(@color) if _.isNumber(@color)

    @draw graph, linearX, linearY

  draw: (graph, linearX, linearY) ->
    @el = graph
    .append 'line'
    .classed 'line', true

    @update(linearX, linearY)

  update: (linearX, linearY) ->
    [@linearX, @linearY] = [linearX, linearY] if linearX? and linearY?
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

  getColor: -> @color
  getColour: -> @getColor()
  setColor: (color) ->
    @color = colors(color) if _.isNumber(color)
    @color = color if _.isString(color) and color[0] is "#"
    @update()
    @color
  setColour: (colour) -> @setColor(colour)
  Color: (color) -> if color? then @setColor(color) else @getColor()
  Colour: (colour) -> @Color(colour)

Line.defaults =
  strokeWidth: 2
  color: colors(0)

module.exports = Line
