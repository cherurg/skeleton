_ = require './utils.coffee'

class LinePure
  defaults: {}

  constructor: (coordinates, options) ->
    if arguments.length is 0
      return

    if coordinates.model is 'Line'
      _.extendDefaults(@, coordinates)
      @coordinates = coordinates.coordinates
      return

    @setCoordinates(coordinates)
    _.extend @, @defaults, _.pick(options, _.keys @defaults)

  getLength: -> Math.sqrt ((@x1 - @x2)**2 + (@y1 - @y2)**2)
  getCoordinates: -> x1: @x1, x2: @x2, y1: @y1, y2: @y2
  setCoordinates: (coordinates) ->
    @x1 = coordinates.x1
    @x2 = coordinates.x2
    @y1 = coordinates.y1
    @y2 = coordinates.y2

module.exports = LinePure