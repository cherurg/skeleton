_ = require 'lodash'

class Wrap
  constructor: ->
    @init()

  add: (el) ->
    @arr.push el
    return _.last @arr

  remove: (el) ->
    # аргумент может быть как номером, так и самим объектом для удаления
    # Что бы это ни было, нужно найти это в массиве и удалить.
    if _.isNumber el
      number = el
      finder = (o, i) -> i is number
    else if el.constructor?
      finder = (o) -> o is el

    #достаем смертинка из массива
    dead = _.find @arr, finder

    unless dead?
      console.log "remove: не найден элемент " + el
      return

    # удаляем смертника
    _.remove @arr, (o) -> o is dead

    return dead

  each: (func) ->
    @arr.forEach(func)

  init: -> @removeAll()
  removeAll: ->
    @arr = []
    @number = 0

  empty: -> @arr.length is 0

module.exports = Wrap