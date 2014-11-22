d3 = require '../libs/d3/d3.js'
_ = require 'lodash'
colors = require './Colors.coffee'

class Func
  constructor: (functionPure, graph, linearX, linearY, options) ->
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
      .attr 'fill', 'none'
      .attr 'stroke-width', @strokeWidth
      .attr 'stroke', @color
      @el.push path
      i
    @update linearX, linearY

  clear: ->
    _.each @el, (f) -> f.remove()

  update: (linearX, linearY) ->
    [@linearX, @linearY] = [linearX, linearY]

    [left, right] = [@getLeft(), @getRight()]
    breaks = _.filter @breaks, (el) -> left < el < right

    for i, el of @el
      path = @getPath parseInt(i), breaks
      el.attr 'd', path

  # Кроме того, можно модифицировать массив точек, не
  # создавая его заново. Смотреть, какие точки остались в
  # окне, а какие вышли за его пределы
  # последнее замечание относится к способу оптимизации.
  getPath: (num, breaks) ->
    return "" if (@getLef t() >= @getRight()) or num > breaks.length

    points = []
    domain = @linearX.domain()
    step = (domain[1] - domain[0])/@accuracy

    minValue = step/10000000
    left = if num > 0
      breaks[num - 1] + minValue
    else
      @getLeft()
    right = if breaks.length > 0 and num isnt breaks.length
      breaks[num] - minValue
    else
      @getRight()

    x = (left // step) * step + step

    points.push x: left, y: @pure.func left

    while x <= right
      y = @pure.func x
      points.push x: x, y: y
      x += step
    points.push x: right, y: @pure.func right unless x is right

    return @path points

  getRight: ->
    return @linearX.domain()[1] unless @pure.getRight()?
    return Math.min @linearX.domain()[1], @pure.getRight()

  getLeft: ->
    return @linearX.domain()[0] unless @pure.getLeft()?
    return Math.max @linearX.domain()[0], @pure.getLeft()

Func.defaults =
  accuracy: 300
  strokeWidth: 2
  color: colors(0)
  breaks: []
  linearX: null
  linearY: null

module.exports = Func