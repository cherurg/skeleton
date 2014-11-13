class PointPure
  constructor: (x, y) ->
    @x = if x? then x else 0
    @y = if y? then y else 0

module.exports = PointPure