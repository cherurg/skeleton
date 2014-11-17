_ = require 'lodash'
PlotPure = require './PlotPure.coffee'
Plot = require './Plot.coffee'
Point = require './Point.coffee'
PointPure = require './PointPure.coffee'
Func = require './Func.coffee'
FuncPure = require './FuncPure.coffee'
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

    @points = new Wrap()
    @functions = new Wrap()

  draw: ->
    @plot.draw()

    [linearX, linearY] = [@plot.x, @plot.y]
    @points.each (point) -> point.draw linearX, linearY
    @functions.each (func) -> func.draw linearX, linearY

  addPoint: (x, y, options) ->
    point = new Point new PointPure(x, y), @plot.graph, @plot.x, @plot.y, options
    @points.addElement point
    return point

  removePoint: (point) ->
    @points.removePoint point

  addFunc: (func, options) ->
    obj = new Func new FuncPure(func), @plot.graph, @plot.x, @plot.y, options
    @functions.addElement obj
    return obj

  removeFunc: (func) ->
    @functions.removeElement func

module.exports = Plotter

# делаем Plotter видимым глобально
window.Plotter = Plotter