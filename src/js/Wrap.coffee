_ = require 'lodash'

class Wrap
  constructor: ->
    @init()

  #устаревшие методы
  addElement: (el) -> @add el
  removeElement: (el) -> @remove el

  add: (el) ->
    @arr.push el: el, number: @number++
    return _.last @arr

  remove: (el) ->
    # аргумент может быть как номером, так и самим объектом для удаления
    # Что бы это ни было, нужно найти это в массиве и удалить.
    if _.isNumber el
      finder = (o) -> o.number is el
    else if el?.constructor?
      finder = (o) -> o.el is el

    #достаем смертинка из массива
    dead = _.find @arr, finder

    unless dead?
      console.log "remove: не найден элемент " + el
      return

    # удаляем смертника
    _.remove @arr, (o) -> o is dead

    return dead.el

  each: (func) ->
    arr = _.map @arr, (o) -> o.el
    _.each arr, func

  init: -> @removeAll()
  removeAll: ->
    @arr = []
    @number = 0

module.exports = Wrap