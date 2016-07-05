#����, ���������� ������ ��� �������� ������ ������� � �����
#��� ����������� �������������


#��������� �� ������� �� ������������, �������, ����������
# � func.el
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
