var plotter = new Plotter('plot');

var options = {
    breaks: [0]
};

plotter.addFunc(function (x) {
    return 1/x;
}, options);

