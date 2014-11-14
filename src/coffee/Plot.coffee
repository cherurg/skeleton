d3 = require '../libs/d3/d3.js'
_ = require 'lodash'

class Plot
  defaults:
    width: 800
    height: 600

  constructor: (elementID, plot, options = {}) ->
    # если elementID не определен, то бросаем исключение.
    # Можно ли это сделать более коротким способом?
    if not elementID?
      throw  @constructor.name + ": Отсутствует ID элемента для рисования"

    # Проверяем, является ли первый символ решеткой (символ id в html в нотации селекторов)
    # если нет, то добавляем решетку.
    @id = if elementID[0] is "#" then elementID else "#" + elementID

    # ищем элемент по указанному ID. Не находим -- ругаемся.
    @el = d3.select @id
    if do @el.empty
      throw @constructor.name + ": Не найден элемент с указанным ID -- " + @id

    # plot должен быть класса PlotPure.
    if not plot? or plot?.constructor?.name isnt "PlotPure"
      throw @constructor.name + ": Неверный аргумент plot -- " + plot
    @pure = plot

    # присвоить классу все свойства из defaults. Если в options будет найдено
    # свойство с уже существующим именем, то оно будет перезаписано
    _.extend @, @defaults, options

  draw: ->
    @el.html ""

    #эти две штуки помогут перевести математически заданные функции в рисунок
    @x = d3.scale.linear()
      .domain [@pure.left, @pure.right]
      .range [0, @width]
    @y = d3.scale.linear()
      .domain [@pure.bottom, @pure.right]
      .range _([0, @height]).reverse().value()
