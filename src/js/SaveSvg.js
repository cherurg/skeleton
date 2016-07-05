import d3 from '../libs/d3/d3.js';

let SaveSvg = (id) => {
      let xml = d3.select(id)
                  .select("svg")
                  .attr("version", 1.1)
                  .attr("xmlns", "http://www.w3.org/2000/svg")
                  .node().outerHTML;
      let imgsrc = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(xml)));
      let a = d3.select('body')
                .append("a")
                .attr('download','graph.svg')
                .attr('href',imgsrc)
                .node()
                .click();
};

module.exports = SaveSvg;