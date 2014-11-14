d3 = require '../libs/d3/d3.js'
_ = require 'lodash'
PlotPure = require './PlotPure.coffee'

class Plot
  defaults:
    width: 800
    height: 600
    stroke: '#000000'
    vertical: 20
    horizontal: 30
    ticks: 10
    transformX: (d) -> "translate(" + @x(d) + ",0)"
    transformY: (d) -> "translate(0," + @y(d) + ")"
    lineWidth: (d) -> if d then "1" else "2"
    lineColor: (d) -> if d then "#ccc" else "#666"
    tickNull: (d) -> if Math.abs(d) < 1e-10 then 0 else d

  constructor: (elementID, plotPure, options = {}) ->
    # если elementID не определен, то бросаем исключение.
    # Можно ли это сделать более коротким способом?
    if not elementID?
      throw  @constructor.name + ": Отсутствует ID элемента для рисования"

    # Проверяем, является ли первый символ решеткой (символ id в html в нотации селекторов)
    # если нет, то добавляем решетку.
    @id = if elementID[0] is "#" then elementID else "#" + elementID

    # ищем элемент по указанному ID. Не находим -- ругаемся.
    @el = d3.select @id
    if do @el.empty
      throw @constructor.name + ": Не найден элемент с указанным ID -- " + @id
    @el
    .style 'cursor', 'default'
    .style '-moz-user-select', '-moz-none'
    .style '-o-user-select', 'none'
    .style '-khtml-user-select', 'none'
    .style '-webkit-user-select', 'none'
    .style 'user-select', 'none'

    # plot должен быть класса PlotPure.
    if not plotPure? or plotPure?.constructor?.name isnt "PlotPure"
      throw @constructor.name + ": Неверный аргумент plot -- " + plotPure
    @pure = plotPure

    # присвоить классу все свойства из defaults. Если в options будет найдено
    # свойство с уже существующим именем, то оно будет перезаписано
    _.extend @, @defaults, options

    @el.html ''
    @svg = @el
    .append 'svg'
    .attr 'width', @width + @horizontal   #здесь еще нужно добавить пикселей для оси
    .attr 'height', @height + @vertical   #здесь тоже
    @svg
    .append 'rect'
    .attr 'width', @width
    .attr 'height', @height
    .attr 'stroke-width', 1 #по какой-то причине границы снизу и справа шире, чем слева и сверху
    .attr 'stroke', @stroke
    .attr 'fill-opacity', 0

    @graph = @svg
    .append 'svg'
    .attr 'width', @width
    .attr 'height', @height
    .attr 'viewBox', "0 0 " + @width + " " + @height

  draw: ->
    #эти две штуки помогут перевести математически заданные функции в рисунок
    @x = d3.scale.linear()
      .domain [@pure.left, @pure.right]
      .range [0, @width]
    @y = d3.scale.linear()
      .domain [@pure.bottom, @pure.top]
      .range _([0, @height]).reverse().value()

    ######
    # прорисовка вертикальных линий
    xTicks = @x.ticks @ticks
    .map @tickNull

    gx = @svg.selectAll 'g.x'
    .data(xTicks, String)
    .attr "transform", @transformX.bind @

    gxe = gx.enter().append 'g'
    .classed 'x', true
    .attr 'transform', @transformX.bind @

    gxe.append 'line'
    .attr 'stroke', @lineColor
    .attr 'stroke-width', @lineWidth
    .attr 'y1', 0
    .attr 'y2', @height

    gxe.append 'text'
    .classed 'axis', true
    .attr 'y', @height
    .attr 'dy', '1em'
    .attr 'text-anchor', 'middle'
    .text @x.tickFormat @ticks

    gx.exit().remove()

    ######
    # прорисовка горизонтальных линий
    yTicks = @y.ticks @ticks
    .map @tickNull

    gy = @svg.selectAll 'g.y'
    .data(yTicks, String)
    .attr "transform", @transformY.bind @

    gye = gy.enter().append 'g'
    .classed 'y', true
    .attr 'transform', @transformY.bind @

    gye.append 'line'
    .attr 'stroke', @lineColor
    .attr 'stroke-width', @lineWidth
    .attr 'x1', 0
    .attr 'x2', @width


    gye.append 'text'
    .classed 'axis', true
    .attr 'x', @width
    .attr 'dx', '1em'
    .attr 'text-anchor', 'middle'
    .text @y.tickFormat @ticks

    gy.exit().remove()


    console.log @ + " is drawn"

  getGraph: -> @graph

###
plot = new Plot 'plot', new PlotPure()
plot.draw()###
