d3 = require '../libs/d3/d3.js'
_ = require 'lodash'
colors = require './Colors.coffee'

class Func
  constructor: (functionPure, graph, linearX, linearY, options) ->
    @pure = functionPure
    _.extend @, Func.defaults, _.pick(options, _.keys Func.defaults)

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

    @draw linearX, linearY

  # можно поменять алгоритм обсчета пути
  # суть в том, чтобы график рассчитывала в константных
  # точках, которые не зависят от перемещения окна графика
  # их можно сделать, если рассчитывать отступ не от края
  # окна, а от нуля.
  # Кроме того, можно модифицировать массив точек, не
  # создавая его заново. Смотреть, какие точки остались в
  # окне, а какие вышли за его пределы
  # последнее замечание относится к способу оптимизации.
  getPath: (num) ->
    points = []
    domain = @linearX.domain()
    step = (domain[1] - domain[0])/@accuracy

    minValue = step/10000
    left = if num > 0
      @breaks[num - 1] + minValue
    else
      @getLeft()
    right = if @breaks.length > 0 and num isnt @breaks.length
      @breaks[num] - minValue
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

  draw: (linearX, linearY) ->
    [@linearX, @linearY] = [linearX, linearY]
    do @update

  update: ->
    for i, el of @el
      el.attr 'd', @getPath parseInt i

  getRight: ->
    return @linearX.domain()[1] unless @pure.getRight()?
    return Math.max @linearX.domain()[1], @pure.getRight()

  getLeft: ->
    return @linearX.domain()[0] unless @pure.getLeft()?
    return Math.min @linearX.domain()[0], @pure.getLeft()

Func.defaults =
  accuracy: 300
  strokeWidth: 2
  color: colors(0)
  breaks: []

module.exports = Func