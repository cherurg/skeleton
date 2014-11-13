d3 = require '../libs/d3/d3.js'
_ = require 'lodash'

class Point
  constructor: (point, options) ->
    @pure = point
    _.extend(@, @defaults, options)

  draw: ->

  defaults: {}