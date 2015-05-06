var plot = new Plotter('plot');

var point = plot.addPoint(1, 1, {
  onMove: function (x, y) {
    console.log('(' + x + ', ' + y + ')');
   }
});
point.Movable(true);