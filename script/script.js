var plotter = new Plotter("plot");
plotter.draw();
var point = plotter.addPoint(2, 2);
point.setSize('tiny');
point.update();