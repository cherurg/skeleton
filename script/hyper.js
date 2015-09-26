var plotter = new Plotter('plot');

var options = {
  breaks: [0]
};

plotter.addFunc(function (x) {
  return 1 / x;
}, options);

var setTop = setTimeout(function () {
  plotter.plot.y.domain([plotter.plot.pure.bottom, 10]);
  plotter.draw();
}, 2000);

