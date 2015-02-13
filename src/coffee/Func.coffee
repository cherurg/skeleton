d3 = require '../libs/d3/d3.js'
_ = require 'lodash'
Colors = require('./Colors.coffee')('Color')
Colours = require('./Colors.coffee')('Colour', 'color')

class Func
  _.extend(@::, Colors::, Colours::)

  constructor: (functionPure, graph, linearX, linearY, options = {}) ->
    @pure = functionPure
    _.extend @, Func.defaults, _.pick(options, _.keys Func.defaults)
    @breaks = _.sortBy @breaks, (el) -> return el

    @draw graph, linearX, linearY

  draw: (graph, linearX, linearY) ->
    self = @
    @path = d3.svg.line()
    .x (d) -> self.linearX d.x
    .y (d) -> self.linearY d.y

    @g = graph
    .append 'g'

    @el = []
    for i in [0..@breaks.length]
      path = @g
      .append 'path'
      .classed 'function', true
      @el.push path
      i
    @update linearX, linearY

  clear: ->
    _.each @el, (f) -> f.remove()

  update: (linearX, linearY) ->
    [@linearX, @linearY] = [linearX, linearY] if linearX? and linearY?

    [left, right] = [@left(), @right()]
    @currentBreaks = _.filter @breaks, (el) -> left < el < right

    for i, el of @el
      el.attr 'd', @getPath(parseInt(i))
      .attr 'fill', 'none'
      .attr 'stroke-width', @strokeWidth
      .attr 'stroke', @Color()

  # Кроме того, можно модифицировать массив точек, не
  # создавая его заново. Смотреть, какие точки остались в
  # окне, а какие вышли за его пределы
  # последнее замечание относится к способу оптимизации.
  getPath: (num) ->
    return "" if (@left() >= @right()) or num > @currentBreaks.length

    points = []
    domain = @linearX.domain()
    step = (domain[1] - domain[0])/@accuracy

    minValue = step/10000000
    left = if num > 0
      @currentBreaks[num - 1] + minValue
    else
      @left()
    right = if @currentBreaks.length > 0 and num isnt @currentBreaks.length
      @currentBreaks[num] - minValue
    else
      @right()

    x = (left // step) * step + step

    points.push x: left, y: @yMax(@pure.func left)
    while x <= right
      y = @pure.func x
      points.push x: x, y: @yMax(y)
      x += step
    points.push x: right, y: @yMax(@pure.func right) unless x is right

    return @path points

  right: ->
    return @linearX.domain()[1] unless @pure.getRight()?
    return Math.min @linearX.domain()[1], @pure.getRight()

  left: ->
    return @linearX.domain()[0] unless @pure.getLeft()?
    return Math.max @linearX.domain()[0], @pure.getLeft()

  yMax: (y) ->
    top = 1000000
    y = if y > top
      top
    else if y < -top
      -top
    else y

  getAccuracy: -> @accuracy
  setAccuracy: (accuracy) ->
    @accuracy = accuracy
    @update()
    accuracy
  Accuracy: (accuracy) ->
    if accuracy? then @setAccuracy(accuracy) else @getAccuracy()

  getStrokeWidth: -> @strokeWidth
  setStrokeWidth: (strokeWidth) ->
    @strokeWidth = strokeWidth
    @update()
    strokeWidth
  strokeWidth: (strokeWidth) ->
    if strokeWidth? then @setStrokeWidth(strokeWidth) else @getStrokeWidth()

  getBreaks: -> @breaks
  setBreaks: (breaks) -> @breaks = breaks
  Breaks: (breaks) -> if breaks? then @setBreaks(breaks) else @getBreaks()

  getLeft: -> @pure.getLeft()
  setLeft: (left) -> @pure.setLeft(left)
  Left: (left) -> if left? then @setLeft(left) else @getLeft()

  getRight: -> @pure.getRight()
  setRight: (right) -> @pure.setRight(right)
  Right: (right) -> if right? then @setRight(right) else @getRight()

  getFunc: -> @pure.func
  setFunc: (func) -> @pure.func = func
  Func: (func) -> if func? then @setFunc(func) else @getFunc()

  getPathQuantity: -> @pathQuantity()
  pathQuantity: -> @el.length

Func.defaults =
  accuracy: 800
  strokeWidth: 2
  color: 0
  breaks: []

module.exports = Func