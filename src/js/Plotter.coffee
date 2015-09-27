_ = require './utils.coffee'
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
ParametricFunc = require './ParametricFunc.coffee'
ee = require 'event-emitter'
OverContainer = require './OverContainer.coffee'

class Plotter
  constructor: (elementID, options) ->
    _.extend(@, options)
    if @communicate isnt false
      @communicate = true

    @type = Plotter.type

    @id = elementID

    @emitter = ee @

    @plot = new Plot @id, new PlotPure(options), options
    @plot.emitter.on 'draw', =>
      @draw()
      if @plot.onDrawCallback then @plot.onDrawCallback(@plot)

    @elements = new Wrap()

    if window.overContainer?
      window.overContainer.add @

    @draw()

  update: -> @draw()
  redraw: -> @draw()
  draw: ->
    @plot.draw()
    @elements.each (element) -> element.update()
    if @communicate then @emitter.emit('drawn')

    return @

  addPoint: (x, y, options) ->
    pure = if arguments.length is 3 or arguments.length is 2
      new PointPure(x, y, options)
    else if arguments.length is 1
      x

    point = new Point pure, @plot.graph, @plot.x, @plot.y, options
    @elements.add point

    return point

  point: (x, y, options) -> @addPoint(x, y, options)

  addFunc: (func, options = {}) ->
    options?.accuaracy ?= @plot.width
    obj = if func.model is 'Func'
      new Func func, @plot.graph, @plot.x, @plot.y, options
    else
      pure = new FuncPure(func, options)
      new Func pure, @plot.graph, @plot.x, @plot.y, options
    @elements.add obj
    return obj

  func: (func, options) -> @addFunc(func, options)

  addArea: (array, options) ->
    area = if array.model is 'ParametricArray'
      new ParametricArray array, @plot.graph, @plot.x, @plot.y, options
    else
      pure = new ParametricArrayPure(array, options)
      new ParametricArray pure, @plot.graph, @plot.x, @plot.y, options

    @elements.add area
    return area

  area: (array, options) -> @addArea(array, options)

  addShadedArea: (func, options) -> @shadedArea(func, options)

  shadedArea: (func, options = {}) ->
    options?.accuaracy ?= @plot.width

    localOptions = {}

    func = if _.isFunction(func) or func.model is 'Func'
      _.extend localOptions, options
      func

    else if _.isFunction(func.pure?.getFunc())
      keys = (object) ->
        _(object)
        .keys()
        .difference(ShadedArea::defaults.ownDefaults)
        .value()

      _.extend localOptions, _.pick(func, keys(Func::defaults))
      _.extend localOptions, _.pick(func.pure, keys(FuncPure::defaults))
      func.pure.getFunc()

    else
      ex = "shadedArea: неверный тип аргумента func."
      ex += " Должен быть Function или Func."
      throw new Exception ex

    pure = new FuncPure(func, localOptions)
    obj = new ShadedArea pure, @plot.graph, @plot.x, @plot.y, localOptions
    @elements.add obj
    return obj

  parametricFunc: (array, options) ->
    pure = new ParametricArrayPure(array, options)
    parametricFunc = new ParametricFunc pure,
      @plot.graph, @plot.x, @plot.y, options

    @elements.add parametricFunc
    return parametricFunc

  addParametricFunc: (array, options) -> @parametricFunc(array, options)

  addLine: (x1, y1, x2, y2, options) ->
    pure = if arguments.length is 4 or arguments.length is 5
      new LinePure({x1: x1, y1: y1, x2: x2, y2: y2}, options)

    else if arguments.length is 1
      x1

    line = new Line(pure, @plot.graph, @plot.x, @plot.y, options)
    @elements.add line
    return line

  remove: (element) ->
    element = @elements.remove element
    element.clear()

  removeAll: ->
    @elements.each (el) -> el.clear()
    @elements.removeAll()

  getID: -> @id

  getModel: ->
    properties =
      plot: @plot.getModel()
      elements: []

    @elements.each (el) =>
      properties.elements.push el.getModel()

    properties

  setModel: (model) ->
    @plot.setModel(model.plot, silent: true)

    unless @elements.empty()
      @elements.each (el, i) =>
        el.setModel(model.elements[i], silent: true)
    else
      model.elements.forEach (el) =>
          this[el.model](el)

    @update()

  getPlot: -> @plot

Plotter.version = "0.1.0"
Plotter.type = null

module.exports = Plotter

# делаем Plotter видимым глобально
window.Plotter = Plotter
window.Skeleton = Plotter;
window._ = _;

window.OverContainer = OverContainer
