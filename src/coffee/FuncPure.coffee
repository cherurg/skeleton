_ = require 'lodash'

class FuncPure
  defaults:
    left: null
    right: null

  constructor: (func, options) ->
    @func = func
    _.extend @, @defaults, _.pick(options, _.keys @defaults)

  getRight: -> @right
  setRight: (right) -> @right = right

  getLeft: -> @left
  setLeft: (left) -> @left = left

  getFunc: -> @func


module.exports = FuncPure