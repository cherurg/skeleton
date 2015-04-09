_ = require 'lodash'

class LinePure
  constructor: (coordinates, options) ->
    @x1 = coordinates.x1
    @x2 = coordinates.x2
    @y1 = coordinates.y1
    @y2 = coordinates.y2
    _.extend @, LinePure.defaults, _.pick(options, _.keys LinePure.defaults)

  getLength: -> Math.sqrt ((@x1 - @x2)**2 + (@y1 - @y2)**2)

LinePure.defaults = {}

module.exports = LinePure