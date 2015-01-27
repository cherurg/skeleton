(function () {
    var plotter = new Plotter("plot");

    var sin = function (x) {
        return Math.sin(1 / x);
    };

    plotter.addFunc(sin, {
        right: -0.2
    });

    plotter.addFunc(sin, {
        left: 0.2
    });

    plotter.addFunc(sin, {
        left: -0.2,
        right: 0.2,
        accuracy: 5000,
        breaks: [0]
    })
}());