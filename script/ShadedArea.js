var plot = new Plotter('plot');

var func = plot.func(function (x) {
    return 1/(x);
}, {
    breaks: [0],
    left: -1,
    right: 1
});

var area = plot.shadedArea(function (x) {
    return 1/(x);
}, {
    breaks: [0],
    left: -1,
    right: 1
});


var shadedArea = plot.shadedArea(function (x) {
    return x;
}, {
    left: 0,
    right: 2,
    color: 7
});
