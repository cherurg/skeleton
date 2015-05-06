var p = new Plotter('plot');

var line = p.addLine(0, 0, 1, 1);

var points = [
  p.addPoint(0, 0, {
    onMove: function (x, y) {
      line.setX1(x);
      line.setY1(y);
    }
  }),
  p.addPoint(1, 1, {
    onMove: function (x, y) {
      line.setX2(x);
      line.setY2(y);
    }
  })
];