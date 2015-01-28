_ = require 'lodash'
PlotPure = require './PlotPure.coffee'
Plot = require './Plot.coffee'
Point = require './Point.coffee'
PointPure = require './PointPure.coffee'
Func = require './Func.coffee'
FuncPure = require './FuncPure.coffee'
ParametricArray = require './ParametricArray.coffee'
ParametricArrayPure = require './ParametricArrayPure.coffee'
Line = require './Line.coffee'
LinePure = require './LinePure.coffee'
Wrap = require './Wrap.coffee'

class Plotter
  constructor: (elementID, options = {}) ->
    _.extend(@, options)

    @id = elementID

    #берем стандартные свойства из Plot.defaults и оставляем в plotOptions
    # только те свойства из options, которые существуют в Plot.defaults
    plotOptions = _ options
    .pick _.keys(Plot.defaults)
    .value()
    plotPureOptions = _ options
    .pick _.keys(PlotPure.defaults)
    .value()

    @plot = new Plot @id, new PlotPure(plotPureOptions), plotOptions
    self = @
    @plot.emitter.on 'draw', () -> self.draw()

    @elements = new Wrap()
    @draw()

  redraw: -> @draw()

  draw: ->
    @plot.draw()
    [linearX, linearY] = [@plot.x, @plot.y]
    @elements.each (element) -> element.update linearX, linearY

    return @

  addPoint: (x, y, options) ->
    point = new Point new PointPure(x, y, options), @plot.graph, @plot.x, @plot.y, options
    @elements.addElement point
    return point

  addFunc: (func, options) ->
    options?.accuaracy ?= @plot.width
    obj = new Func new FuncPure(func, options), @plot.graph, @plot.x, @plot.y, options
    @elements.addElement obj
    return obj

  addArea: (array, options) ->
    area = new ParametricArray new ParametricArrayPure(array, options), @plot.graph, @plot.x, @plot.y, options
    @elements.addElement area
    return area

  addLine: (x1, y1, x2, y2, options) ->
    pure = new LinePure(x1, y1, x2, y2, options)
    line = new Line(pure, @plot.graph, @plot.x, @plot.y, options)
    @elements.addElement line
    return line

  addParametricFunc: (functionX, functionY, options = {}) ->
    ###if _.isArray(functionX) and _.isArray(functionY)
  arrayX = functionX
  arrayY = functionY
  else
  unless options.step? and options.left? and options.right?
    console.warn "Не указаны границы или шаг t в options метода addParametricFunc! Взяты значения по-умолчанию."

  [arrayX, arrayY] = ([functionX(t), functionY(t)] for t in [options.left..options.right] by options.step)###

  remove: (element) ->
    element = @elements.removeElement element
    element.clear()

  getID: -> @id

Plotter.version = "0.0.5"
module.exports = Plotter

# делаем Plotter видимым глобально
window.Plotter = Plotter
window._ = _;