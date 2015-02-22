var plot = new Plotter('plot');

var func = plot.func(function (x) {
    return 1/(x);
}, {
    breaks: [0]
});

var area = plot.shadedArea(func);
