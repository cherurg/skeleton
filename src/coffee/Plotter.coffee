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
ShadedArea = require './ShadedArea.coffee'
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
    @plot.emitter.on 'draw', () => @draw()

    @elements = new Wrap()
    @draw()

  redraw: -> @draw()

  draw: ->
    @plot.draw()
    @elements.each (element) -> element.update()

    return @

  addPoint: (x, y, options) ->
    point = new Point new PointPure(x, y, options), @plot.graph, @plot.x, @plot.y, options
    @elements.addElement point
    return point

  point: (x, y, options) -> @addPoint(x, y, options)

  addFunc: (func, options) ->
    options?.accuaracy ?= @plot.width
    obj = new Func new FuncPure(func, options), @plot.graph, @plot.x, @plot.y, options
    @elements.addElement obj
    return obj

  func: (func, options) -> @addFunc(func, options)

  addArea: (array, options) ->
    area = new ParametricArray new ParametricArrayPure(array, options), @plot.graph, @plot.x, @plot.y, options
    @elements.addElement area
    return area

  area: (array, options) -> @addArea(array, options)

  addShadedArea: (func, options) -> @shadedArea(func, options)

  shadedArea: (func, options = {}) ->
    options?.accuaracy ?= @plot.width

    localOptions = {}

    func = if _.isFunction(func)
      _.extend localOptions, options
      func

    else if _.isFunction(func.pure.getFunc())
      keys = (object) ->
        _(object)
        .keys()
        .difference(ShadedArea::defaults.ownDefaults)
        .value()

      _.extend localOptions, _.pick(func, keys(Func::defaults))
      _.extend localOptions, _.pick(func.pure, keys(FuncPure::defaults))

      func.pure.getFunc()

    else
      throw new Exception "shadedArea: неверный тип аргумента func. Должен быть Function или Func."

    obj = new ShadedArea new FuncPure(func, localOptions), @plot.graph, @plot.x, @plot.y, localOptions
    @elements.addElement obj
    return obj

  addLine: (x1, y1, x2, y2, options) ->
    pure = new LinePure(x1, y1, x2, y2, options)
    line = new Line(pure, @plot.graph, @plot.x, @plot.y, options)
    @elements.addElement line
    return line

  remove: (element) ->
    element = @elements.removeElement element
    element.clear()

  removeAll: ->
    @elements.each (el) -> el.clear()
    @elements.removeAll()

  getID: -> @id

Plotter.version = "0.0.7"
module.exports = Plotter

# делаем Plotter видимым глобально
window.Plotter = Plotter
window._ = _;