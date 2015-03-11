d3 = require '../libs/d3/d3.js'
_ = require 'lodash'
Colors = require('./Colors.coffee')('Color')
Colours = require('./Colors.coffee')('Colour', 'color')

class Point
  _.extend(@::, Colors::, Colours::)

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

    # сделать у @ свойство drag.
    Point.behavior.call @, @behaviorType

    @el = graph
    .append 'circle'
    .classed 'point', true
    .on 'mousedown', =>
      # когда нажимаем на точку со свойством movable, то нам нужно позаботиться
      # о том, чтобы с движением точки не обрабатывалось еще и событие zoom
      # графика. stopPropagation нам в этом помогает.
      d3.event.stopPropagation() if @movable
    .call @drag
    [@linearX, @linearY] = [linearX, linearY] if linearX? and linearY?
    @update()

  update: () ->
    @el
    .attr 'cx', @linearX @pure.x
    .attr 'cy' ,@linearY @pure.y
    .attr 'r', @size
    .attr 'fill', @Color()

  clear: ->
    @el.remove()

  setSize: (size) ->
    if _.isNumber size
      @size = size
    else if _.isString size
      @size = @sizeScale size

    @update() if @el?

  getSize: -> @size
  Size: (size) -> if size? then @setSize(size) else @getSize()

  getX: () ->  @pure.x
  setX: (x) -> @pure.x = x
  X: (x) -> if x? then @setX(x) else @getX()

  getY: () ->  @pure.y
  setY: (y) -> @pure.y = y
  Y: (y) -> if y? then @setY(y) else @getY()

  setMovable: (movable) -> @movable = movable
  getMovable: -> @movable
  Movable: (movable) -> if movable? then @setMovable(movable) else @getMovable()

######
# поведения и их описания

Point.freeBehavior = ->
  @el
  .attr 'cx', d3.event.x
  .attr 'cy', d3.event.y

  @pure.x = @linearX.invert @el.attr('cx')
  @pure.y = @linearY.invert @el.attr('cy')

Point._behaviorTemplate = (behavior) ->
  =>
    return unless @movable
    behavior?.call @

Point.behavior = (type) ->
  return unless _.isString type

  @drag ?= d3.behavior.drag()

  # в случае, если в рантайме нужно будет поменять поведение, то достаточно
  # будет изменить функцию, вызываемую .on 'drag'
  behaviour = Point.behaviorTypes[type].bind(@)
  @drag
  .on 'drag', Point._behaviorTemplate.call(@, behaviour)

  return @drag

Point.behaviorTypes =
  'free': Point.freeBehavior

Point.defaults =
  movable: false
  color: 6 #d62728 - красный
  size: 3
  behaviorType: 'free'

module.exports = Point