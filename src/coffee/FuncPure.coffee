_ = require 'lodash'

class FuncPure
  constructor: (func, options) ->
    @func = func
    _.extend @, FuncPure.defaults, _.pick(options, _.keys FuncPure.defaults)

  getRight: -> @right
  setRight: (right) -> @right = right

  getLeft: -> @left
  setLeft: (left) -> @left = left

FuncPure.defaults =
  left: null
  right: null

module.exports = FuncPure