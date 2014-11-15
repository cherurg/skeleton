_ = require 'lodash'

class Wrap
  constructor: ->
    @arr = []
    @number = 0 # персональные идентификаторы элементов. Возможно, не очень
  # элегантно, но, вроде, идея и реализация очень простые. Если придумаю
  # что-то лучше, то сделаю.

  addElement: (el) ->
    @arr.push el: el, number: @number++
    return _.last @arr

  removeElement: (el) ->
    # аргумент может быть как номером, так и самим объектом для удаления
    # Что бы это ни было, нужно найти это в массиве и удалить.
    if _.isNumber el
      finder = (o) -> o.number is el
    else if el?.constructor?
      finder = (o) -> o is el

    #достаем смертинка из массива
    dead = _.find @arr, finder

    unless dead?
      console.log "removeElement: не найден элемент " + el
      return

    # удаляем смертника
    _.remove @arr, (o) -> o is dead

  each: (func) ->
    arr = _.map @arr, (o) -> o.el
    _.each arr, func

module.exports = Wrap