_ = require 'lodash'
PlotPure = require './PlotPure.coffee'
Plot = require './Plot.coffee'
Point = require './Point.coffee'
PointPure = require './PointPure.coffee'
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
    @plot = new Plot @id, new PlotPure(), plotOptions

    @points = new Wrap()

  draw: ->
    @plot.draw()

  addPoint: (x, y, options) ->
    point = new Point new PointPure(), @plot.graph, options
    @points.addElement point
    return point


module.exports = Plotter

# делаем Plotter видимым глобально
window.Plotter = Plotter