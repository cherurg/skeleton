var plotter = new Plotter("plot");
plotter.draw();
var point = plotter.addPoint(1.5, 1.5, {size: 'large', movable: false});
point.movable = true;
//point.setSize('tiny');
//point.update();