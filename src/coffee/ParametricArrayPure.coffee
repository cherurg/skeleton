_ = require './utils.coffee'

class ParametricArrayPure
  defaults: {}

  constructor: (array, options) ->
    if array.model is 'ParametricArray'
      _.extendDefaults(@, array)
      @array = array.array
      return

    @array = array
    _.extend @, @defaults, _.pick(options, _.keys @defaults)

  getX: (index) -> @array[index].x
  getY: (index) -> @array[index].y

module.exports = ParametricArrayPure