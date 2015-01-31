var sun = new Plotter("plot",{
left:-10, right:10, top:10, bottom:-10, height:500, width:600});

sun.draw();
var a = 5;

var options = {
 left: -a,
 right: a,
 top: a,
 bottom: -a
 };

sun.addFunc( function(x) {
   //return Math.sqrt((1- Math.pow(x,2)/Math.pow(a,2))*Math.pow(a,2)); 
     return Math.sqrt((1- Math.pow(x-1,2)/Math.pow(a,2))*Math.pow(a,2)); 
 },options);