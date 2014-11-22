_ = require 'lodash'

class ParametricArrayPure
  constructor: (array, options) ->
    @array = array
    _.extend @, ParametricArrayPure.defaults, _.pick(options, _.keys ParametricArrayPure.defaults)

  getX: (index) -> @array[index].x
  getY: (index) -> @array[index].y

ParametricArrayPure.defaults = {}

module.exports = ParametricArrayPure