var container = new PlotContainer("plot");

var controls = new app.Controls(container.addEmptyDiv());

var plot = container.addPlot();

var func = plot.addFunc(function (x) {
    return x;
});


var text = "Коэффициент a: ";
var range = controls.addRange(function (value) {
    range.setText(text + value);
    plot.remove(func);
    func = plot.addFunc(function (x) {
        return value*x;
    });

}, text + "1", -1, 1, 0.01, 1);