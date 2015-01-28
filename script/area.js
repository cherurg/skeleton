var plotter = new Plotter("plot", {
    left: -5,
    right: 5
});

var array = [];
array.push({
    x: 0,
    y: 0
});
array.push({
    x: 1,
    y: 0
});
array.push({
    x: 0.5,
    y: 1
});
array.push({
    x: 0,
    y: 0
});

var area = plotter.addArea(array, {
    strokeWidth: 1
});

var line = plotter.addLine(0, 0, 1, 1);

//plotter.removeArea(area);