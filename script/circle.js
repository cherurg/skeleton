var plot = new Plotter("plot", {
    left: -3,
    right: +3,
    bottom: -3,
    top: 3,
    width: 600,
    height: 600
});

var arr = [];
var i;
for (i = 0; i < 2*Math.PI; i += 0.01) {
    arr.push({
        x: Math.cos(i),
        y: Math.sin(i)
    });
}

var area = plot.addArea(arr, {
    fillOpacity: 0.6,
    fill: 10
});

//area.Fill(10);