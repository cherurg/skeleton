import d3 from '../libs/d3/d3';
import {extend, clone} from './utils.coffee';

import Wrap from './Wrap.coffee';
import Plotter from './Plotter';
import OverContainer from './OverContainer';

class PlotContainer {
  constructor(elementID, options = {}) {
    this.id = elementID;

    this.attrs = extend({}, options);

    this.plotters = new Wrap();
    this.plotterCounter = 0;
  }

  getAttrs() {
    return this.attrs;
  }

  getId() {
    //returns WITHOUT '#'
    return this.id;
  }

  getPlotters() {
    return this.plotters;
  }

  getPlottersNumber() {
    return this.plotterCounter;
  }

  addPlot(options) {
    let id = this.addEmptyDiv();
    let plotter = new Plotter(id, options);
    this.plotters.add(plotter);
    return plotter;
  }

  addEmptyDiv() {
    let newDivId = 'plotter' + this.plotterCounter++;

    d3.select('#' + this.id)
      .append('div')
      .attr('id', newDivId);

    return newDivId;
  }
}

window.PlotContainer = PlotContainer;
window.OverContainer = OverContainer;
export {PlotContainer};
export {Plotter};
