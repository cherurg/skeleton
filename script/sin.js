var plotter = new Plotter("plot", {width: 400, height: 400});
plotter.draw();

var options = {
    breaks: [0]
};
plotter.addFunc(function (x) {
    return Math.sin(x)/x;
}, options);