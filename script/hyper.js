var plotter = new Plotter('plot');
plotter.draw();

var options = {
    left: -1,
    right: 1,
    breaks: [0]
};

plotter.addFunc(function (x) {
    return 1/x;
}, options);