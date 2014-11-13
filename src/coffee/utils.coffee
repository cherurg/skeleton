copyOptions = (obj, options) ->
  #перебираем имена всеъ свойств из default и ищем их в options.
  #если находим, то записываем в свойства @. Если не находим, то берем
  #значение из default и записываем в @.
  for value, name of obj.default
    unless obj.default.hasOwnProperty(value)
      continue
    obj[name] = if options?[name]? then options[name] else value

exports.copyOptions = copyOptions