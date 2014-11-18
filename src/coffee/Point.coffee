d3 = require '../libs/d3/d3.js'
_ = require 'lodash'
colors = require './Colors.coffee'

class Point
  constructor: (pointPure, graph, linearX, linearY, options) ->
    @pure = pointPure
    _.extend(@, Point.defaults, options)

    @draw graph, linearX, linearY

  # аргументы принадлежат типу d3.linear
  draw: (graph, linearX, linearY) ->
    # используется в setSize
    @sizeScale = d3
    .scale
    .ordinal()
    .domain ["large", "medium", "small", "tiny"]
    .range [5, 3, 2, 1.5]

    # на случай, если в options размер был указан словом, а цвет - цифрой
    @setSize @size
    @setColor @color


    # сделать у @ свойство drag.
    Point.behavior.call @, @behaviorType

    self = @
    @el = graph
    .append 'circle'
    .classed 'point', true
    .on 'mousedown', ->
      # когда нажимаем на точку со свойством movable, то нам нужно позаботиться
      # о том, чтобы с движением точки не обрабатывалось еще и событие zoom
      # графика. stopPropagation нам в этом помогает.
      d3.event.stopPropagation() if self.movable
    .call @drag
    @update linearX, linearY

  update: (linearX, linearY) ->
    [@linearX, @linearY] = [linearX, linearY]
    @el
    .attr 'cx', @linearX @pure.x
    .attr 'cy' ,@linearY @pure.y
    .attr 'r', @size
    .attr 'fill', @color

  setSize: (size) ->
    if _.isNumber size
      @size = size
    else if _.isString size
      @size = @sizeScale size

  setColor: (color) ->
    if _.isNumber color
      @color = colors color
    else if _.isString color and color[0] is "#"
      @color = color

  setX: (x) -> @pure.x = x
  setY: (y) -> @pure.y = y
  getX: () ->  @pure.x
  getY: () ->  @pure.y


######
# поведения и их описания

Point.freeBehavior = ->
  @el
  .attr 'cx', d3.event.x
  .attr 'cy', d3.event.y

  @pure.x = @linearX.invert @el.attr('cx')
  @pure.y = @linearY.invert @el.attr('cy')

Point._behaviorTemplate = (behavior) ->
  self = @
  return ->
    return unless self.movable
    behavior.call self

Point.behavior = (type) ->
  return unless _.isString type

  @drag ?= d3.behavior.drag()

  # в случае, если в рантайме нужно будет поменять поведение, то достаточно
  # будет изменить функцию, вызываемую .on 'drag'
  if type is 'free'
    @drag
    .on 'drag', Point._behaviorTemplate.call(@, Point.freeBehavior.bind @)

  return @drag

Point.defaults =
  movable: false
  color: colors(6) #d62728 - красный
  size: 3
  behaviorType: 'free'

module.exports = Point