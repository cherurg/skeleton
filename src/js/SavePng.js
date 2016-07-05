import d3 from '../libs/d3/d3.js';

let SavePng = (id) => {
      let canvas = d3.select('body')
                     .append('canvas')
                     .style('display', 'none');
      let context = canvas.node()
                          .getContext("2d");
      let xml = d3.select(id)
                  .select("svg")
                  .attr("version", 1.1)
                  .attr("xmlns", "http://www.w3.org/2000/svg")
                  .node()
                  .outerHTML;
      let imgsrc = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(xml)));
      let image = new Image();
      image.src = imgsrc;
      canvas.attr('width',d3.select('svg')
    	                    .attr('width'));
      canvas.attr('height', d3.select('svg')
    	                      .attr('height'));
      context.fillStyle = 'white';
      context.fillRect(0, 0, canvas.attr('width'), canvas.attr('height'));
      context.drawImage(image, 0, 0);
      let canvasdata = canvas.node()
                             .toDataURL("image/png");
      let pngimg = '<img src="' + canvasdata + '">';
      d3.select("#pngdataurl").html(pngimg);
      let a = d3.select('body')
                .append('a')
                .attr('download', 'graph.png')
                .attr('href', canvasdata)
                .node()
                .click();
      canvas.remove();
};


module.exports = SavePng;