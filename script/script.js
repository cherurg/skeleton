var plotter = new Plotter("plot");
plotter.draw();
var point = plotter.addPoint(1.5, 1.5, {size: 'large', movable: false});
point.movable = true;
plotter.addFunc(function (x) {
    if (x < 0) {
        return -1;
    } else {
        return 1;
    }
}, {breaks: [0], right: -2, left: 2});
//point.setSize('tiny');
//point.update();