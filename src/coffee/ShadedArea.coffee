Func = require './Func.coffee'
_ = require 'lodash'

class ShadedArea extends Func
  defaults: do ->
    def = _.clone(Func::defaults)
    def.fill = 1
    def.fillOpacity = 0.3
    def.strokeWidth = 0
    def

  getPoints: (num) ->
    points = Func::getPoints.call(@, num)
    return points if points.length is 0

    points.unshift(x: points[0].x, y: 0)
    points.push(x: points[points.length - 1].x, y: 0)
    points

module.exports = ShadedArea