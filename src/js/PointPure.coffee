_ = require './utils.coffee'

class PointPure
  defaults: {}

  constructor: (x, y, options) ->
    if arguments.length is 0
      return

    if x.model is 'Point' and arguments.length is 1
      model = x.model
      _.extendDefaults(@, model)
      @x = model.x
      @y = model.y
      return

    @x = if x? then x else 0
    @y = if y? then y else 0
    _.extend @, @defaults, _.pick(options, _.keys @defaults)


module.exports = PointPure