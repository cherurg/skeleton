_ = require './utils.coffee'
ParametricArray = require './ParametricArray.coffee'

class ParametricFunc extends ParametricArray
  defaults: do ->
    def = _.clone(ParametricArray::defaults)
    def.strokeWidth = 2
    def.color = 0
    def.fillOpacity = 0
    def

  constructor: (parametricArrayPure, graph, linearX, linearY, options = {}) ->
    _.extend options, @defaults
    super(parametricArrayPure, graph, linearX, linearY, options)

module.exports = ParametricFunc