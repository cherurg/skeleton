_ = require './utils.coffee'

class FuncPure
  defaults:
    left: null
    right: null

  constructor: (func, options) ->
    if arguments.length is 0
      return

    if func.model is 'Func'
      _.extendDefaults(@, func)
      @func = func.func
      return

    @func = func
    _.extend @, @defaults, _.pick(options, _.keys @defaults)

  getRight: -> @right
  setRight: (right) -> @right = right

  getLeft: -> @left
  setLeft: (left) -> @left = left

  getFunc: -> @func


module.exports = FuncPure