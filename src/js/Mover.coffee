#‘айл, содержащий методы дл€ переводы любого объекта в любой
#дл€ последующей трансформации


d3 = require '../libs/d3/d3.js'
_ = require 'lodash'

#извлекает из функции ее составл€ющие, объекты, хран€щиес€
# в func.el
simplifyFunc = (func) ->
  breaks = func.getBreaks()
  left = func.getLeft()
  right = func.getRight()
  pure = func.getFunc()

  funcArray = []
  for point, i in breaks
    options = breaks: [point], right: point

    options.left = left if i is 0 and left?

    if i > 0
      lastPoint = breaks[i - 1]
      options.breaks.unshift lastPoint
      options.left = lastPoint

    options.right = right if i is breaks.length - 1 and right?

    funcArray.push(func: func, options: options)

  funcArray
