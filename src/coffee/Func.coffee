d3 = require '../libs/d3/d3.js'
_ = require 'lodash'
Colors = require('./Colors.coffee')('Color')
Colours = require('./Colors.coffee')('Colour', 'color')
Fill = require('./Colors.coffee')('Fill')
FuncPure = require './FuncPure.coffee'

class Func
  _.extend(@::, Colors::, Colours::, Fill::)

  defaults:
    accuracy: 800
    strokeWidth: 2
    color: 0
    breaks: []
    fill: 'none'
    fillOpacity: null

  constructor: (functionPure, graph, linearX, linearY, options = {}) ->
    @pure = functionPure
    _.extend @, @defaults, _.pick(options, _.keys @defaults)
    @breaks = _.sortBy @breaks, (el) -> return el

    @draw graph, linearX, linearY

  draw: (graph, linearX, linearY) ->
    @path = d3.svg.line()
    .x (d) => @linearX d.x
    .y (d) => @linearY d.y

    @g = graph
    .append 'g'

    @el = []
    for i in [0..@breaks.length]
      path = @g
      .append 'path'
      .classed 'function', true
      @el.push path
      i

    [@linearX, @linearY] = [linearX, linearY] if linearX? and linearY?
    @update()

  clear: ->
    _.each @el, (f) -> f.remove()

  update: (pointsArray) ->
    [left, right] = [@left(), @right()]
    @currentBreaks = _.filter @breaks, (el) -> left < el < right

    for el, i in @el
      points = if pointsArray? then pointsArray else @getPoints i
      el.attr 'd', @path(points)
      .attr 'fill', @Fill()
      .attr 'fill-opacity', @fillOpacity
      .attr 'stroke-width', @strokeWidth
      .attr 'stroke', @Color()

  # Кроме того, можно модифицировать массив точек, не
  # создавая его заново. Смотреть, какие точки остались в
  # окне, а какие вышли за его пределы
  # последнее замечание относится к способу оптимизации.
  getPoints: (num, func) ->
    return [] if (@left() >= @right()) or num > @currentBreaks.length

    func = if func? then func else @pure.func

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

    points.push x: left, y: @yMax(func left)
    while x <= right
      y = func x
      points.push x: x, y: @yMax(y)
      x += step
    points.push x: right, y: @yMax(func right) unless x is right

    return points

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

  ######
  #options.delay
  #options.duration
  #func - Function
  moveTo: (func, options = {}) ->

    ######
    # переменные для transition
    delay = options.delay or 0
    duration = options.duration or 500

    for el, i in @el
      do (i) =>
        el.transition "transition " + i + " " + Date.now()
        .delay delay
        .duration duration
        .attrTween 'd', =>
          oldFunc = @pure.func
          (t) =>
            #n = do Date.now
            oldArray = @getPoints(i, oldFunc)
            newArray = @getPoints(i, func)
            # or " " нужно на случай, если oldArray и newArray пусты пусты.
            path = @path(d3.interpolateArray(oldArray, newArray)(t)) or " "
            #console.log(t, do Date.now - n)
            path

        .each "end", =>
          ######
          #новая чистая функция
          @pure = new FuncPure(func, @pure)



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

module.exports = Func
