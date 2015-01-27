var container = new PlotContainer("plot");

var plotter = container.addPlot({
    left: 1,
    right: 2
});

plotter.draw();

var func = plotter.addFunc(function (x) {
    return Math.sin(x)/x;
}, {
    breaks: [0]
});

console.log(func.Accuracy());
console.log(func.Accuracy(10));
console.log(func.Accuracy());