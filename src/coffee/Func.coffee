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

    @el = graph
    .append 'path'
    .classed 'function', true
    .attr 'fill', 'none'
    .attr 'stroke-width', @strokeWidth
    .attr 'stroke', @color

    @draw linearX, linearY

  # можно поменять алгоритм обсчета пути
  # суть в том, чтобы график рассчитывала в константных
  # точках, которые не зависят от перемещения окна графика
  # их можно сделать, если рассчитывать отступ не от края
  # окна, а от нуля.
  # Кроме того, можно модифицировать массив точек, не
  # создавая его заново. Смотреть, какие точки остались в
  # окне, а какие вышли за его пределы
  getPath: ->
    points = []
    domain = @linearX.domain()
    step = (domain[1] - domain[0])/@accuracy
    x = @getLeft()

    while x <= @getRight()
      y = @pure.func x
      points.push x: x, y: y
      x += step

    return @path points

  draw: (linearX, linearY) ->
    [@linearX, @linearY] = [linearX, linearY]
    do @update

  update: ->
    @el.attr 'd', @getPath()

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

module.exports = Func