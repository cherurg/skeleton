Func = require './Func.coffee'
_ = require 'lodash'

class ShadedArea extends Func
  defaults: do ->
    def = _.clone(Func::defaults)
    def.fill = 1
    def.fillOpacity = 0.3
    def.strokeWidth = 0
    def.ownDefaults = ['fill', 'fillOpacity', 'strokeWidth']
    def.axe = 'x'
    def

  getPoints: (num) ->
    points = Func::getPoints.call(@, num)
    return points if points.length is 0

    if @axe is 'x'
      points.unshift(x: points[0].x, y: 0)
      points.push(x: points[points.length - 1].x, y: 0)

    if @axe is 'y'
      x = @pure.getLeft()
      y = @pure.func(x)
      points.unshift(x: x, y: y)
      points.unshift(x: 0, y: points[0].y)

      x = @pure.getRight()
      y = @pure.func(x)
      points.push(x: x, y: y)
      points.push(x: 0, y: points[points.length - 1].y)

    points

module.exports = ShadedArea