_ = require 'lodash'

class PointPure
  constructor: (x, y, options) ->
    @x = if x? then x else 0
    @y = if y? then y else 0
    _.extend @, PointPure.defaults, _.pick(options, _.keys PointPure.defaults)

PointPure.defaults = {}

module.exports = PointPure