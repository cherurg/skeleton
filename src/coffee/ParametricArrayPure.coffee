#_ = require 'lodash'
#
#class ParametricArrayPure
#  constructor: (func, options) ->
#    @func = func
#    _.extend @, ParametricArrayPure.defaults, _.pick(options, _.keys ParametricArrayPure.defaults)
#
#  getRight: -> @right
#  getLeft: -> @left
#
#ParametricArrayPure.defaults =
#  left: null
#  right: null
#
#module.exports = ParametricArrayPure