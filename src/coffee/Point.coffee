d3 = require '../libs/d3/d3.js'
_ = require 'lodash'
colors = require './Colors.coffee'

class Point
  constructor: (pointPure, graph, linearX, linearY, options) ->
    @pure = pointPure
    _.extend(@, @defaults, options)

    # используется в setSize
    @sizeScale = d3
    .scale
    .ordinal()
    .domain ["large", "medium", "small", "tiny"]
    .range [5, 3, 2, 1.5]

    @el = graph
    .append 'circle'
    .classed 'point', true

    @draw linearX, linearY

  # аргументы принадлежат типу d3.linear
  draw: (linearX, linearY) ->
    [@linearX, @linearY] = [linearX, linearY]
    do @update

  update: ->
    @el
    .attr 'cx', @linearX @pure.x
    .attr 'cy' ,@linearY @pure.y
    .attr 'r', @size
    .attr 'fill', @color

  setSize: (size) -> @size = @sizeScale size
  setX: (x) -> @pure.x = x
  setY: (y) -> @pure.y = y
  getX: () ->  @pure.x
  getY: () ->  @pure.y

  defaults:
    movable: false
    color: colors(6) #d62728 - красный
    size: 3

module.exports = Point