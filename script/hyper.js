var plotter = new Plotter('plot');

var options = {
    breaks: [],
    accuracy: 100
};

plotter.addFunc(function (x) {
    return 1/x;
}, options);

