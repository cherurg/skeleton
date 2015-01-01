Wrap = require './Wrap.coffee'
d3 = require '../libs/d3/d3.js'
Plotter = require './Plotter.coffee'
_ = require 'lodash'

class PlotContainer
  constructor: (elementID, options = {}) ->
    @id = @id = if elementID[0] is "#" then elementID else "#" + elementID
    _.extend(@, options)
    @plotters = new Wrap()
    @plotterCounter = 0

  addPlot: (options = {}) ->
    newId = 'plotter' + @plotterCounter++

    d3.select(@id)
    .append('div')
    .attr('id', newId)

    plotter = new Plotter(newId, options)
    @plotters.add plotter
    return plotter

module.exports = PlotContainer
window.PlotContainer = PlotContainer