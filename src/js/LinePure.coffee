_ = require 'lodash'

class LinePure
  constructor: (x1, y1, x2, y2, options) ->
    @x1 = x1
    @x2 = x2
    @y1 = y1
    @y2 = y2
    _.extend @, LinePure.defaults, _.pick(options, _.keys LinePure.defaults)

  getLength: -> Math.sqrt ((@x1 - @x2)**2 + (@y1 - @y2)**2)

LinePure.defaults = {}

module.exports = LinePure