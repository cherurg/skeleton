var plot3 = new Plotter('plot');

plot3.addFunc(function (x) {
    return 2*Math.sqrt(1-x*x);
},0.5,1);