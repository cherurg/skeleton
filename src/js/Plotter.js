import {extend, isFunction, pick} from './utils.coffee';
import PlotPure from './PlotPure.coffee';
import Plot from './Plot.coffee';
import Point from './Point.coffee';
import PointPure from './PointPure.coffee';
import Func from './Func.coffee';
import FuncPure from './FuncPure.coffee';
import ParametricArray from './ParametricArray.coffee';
import ParametricArrayPure from './ParametricArrayPure.coffee';
import Line from './Line.coffee';
import LinePure from './LinePure.coffee';
import ShadedArea from './ShadedArea.coffee';
import Wrap from './Wrap.coffee';
import ParametricFunc from './ParametricFunc.coffee';
import ee from 'event-emitter';
import OverContainer from './OverContainer.coffee';

class Plotter {
  constructor(elementID, options) {
    extend(this, options);
    if (!this.communicate) {
      this.communicate = true
    }

    this.type = Plotter.type;
    this.id = elementID;
    this.emitter = ee(this);

    this.plot = new Plot(this.id, new PlotPure(options), options);
    this.plot.emitter.on('draw', () => {
      this.draw();
      if (this.plot.onDrawCallback) {
        this.plot.onDrawCallback(this.plot);
      }
    });

    this.elements = new Wrap();

    if (window.overContainer !== null && window.overContainer !== undefined) {
      window.overContainer.add(this);
    }

    this.draw();
  }

  update() {
    this.draw();
  }

  redraw() {
    this.draw();
  }

  draw() {
    this.plot.draw();
    this.elements.each(element => element.update());
    if (this.communicate) {
      this.emitter.emit('drawn');
    }

    return this;
  }

  addPoint(x, y, options) {
    let pure = arguments.length === 3 || arguments.length === 2 ?
      new PointPure(x, y, options) :
      x;

    let point = new Point(
      pure,
      this.plot.graph,
      this.plot.x,
      this.plot.y,
      options);
    this.elements.add(point);

    return point;
  }

  point(x, y, options) {
    return this.addPoint(x, y, options);
  }

  addFunc(func, options = {}) {
    options.accuracy = options.accuracy || this.plot.width;
    let funcObject;
    if (func.model === 'Func') {
      funcObject = new Func(
        func,
        this.plot.graph,
        this.plot.x,
        this.plot.y,
        options);

    } else {
      let pure = new FuncPure(func, options);
      funcObject = new Func(
        pure,
        this.plot.graph,
        this.plot.x,
        this.plot.y,
        options);
    }
    this.elements.add(funcObject);
    return funcObject;
  }

  func(func, options) {
    return this.addFunc(func, options);
  }

  addArea(array, options) {
    let area;
    if (array.model === 'ParametricArray') {
      area = new ParametricArray(
        array,
        this.plot.graph,
        this.plot.x,
        this.plot.y,
        options);

    } else {
      let pure = new ParametricArrayPure(array, options);
      area = new ParametricArray(
        pure,
        this.plot.graph,
        this.plot.x,
        this.plot.y,
        options);
    }

    this.elements.add(area);
    return area;
  }

  area(array, options) {
    return this.addArea(array, options);
  }

  addShadedArea(func, options = {}) {
    options.accuracy = options.accuracy || this.plot.width;

    let localOptions = {};
    let pureFunc;
    if (isFunction(func) || func.model === 'Func') {
      extend(localOptions, options);
      pureFunc = func;

    } else if (isFunction(func.pure.getFunc())) {
      let keys = (object) => {
        _(object)
          .keys()
          .difference(ShadedArea.prototype.defaults.ownDefaults)
          .value();
      };

      extend(localOptions, pick(func, keys(Func.prototype.defaults)));
      extend(localOptions, pick(func.pure, keys(FuncPure.prototype.defaults)));
      pureFunc = func.pure.getFunc();

    } else {
      let ex = 'shadedArea: неверный тип аргумента func.';
      ex += ' ƒолжен быть Function или Func.';
      throw new Exception(ex);
    }

    let pure = new FuncPure(pureFunc, localOptions);
    let obj = new ShadedArea(
      pure,
      this.plot.graph,
      this.plot.x,
      this.plot.y,
      localOptions);
    this.elements.add(obj);
    return obj;
  }

  shadedArea(func, options) {
    return this.addShadedArea(func, options);
  }

  addParametricFunc(array, options) {
    let pure = new ParametricArrayPure(array, options);
    let parametricFunc = new ParametricFunc(
      pure,
      this.plot.graph,
      this.plot.x,
      this.plot.y, options);

    this.elements.add(parametricFunc);
    return parametricFunc;
  }

  parametricFunc(array, options) {
    return this.addParametricFunc(array, options);
  }

  addLine(x1, y1, x2, y2, options) {
    let pure;
    if (arguments.length === 4 || arguments.length === 5) {
      pure = new LinePure({x1: x1, y1: y1, x2: x2, y2: y2}, options)

    } else if (arguments.length === 1) {
      pure = x1;
    }

    let line = new Line(
      pure,
      this.plot.graph,
      this.plot.x,
      this.plot.y,
      options
    );
    this.elements.add(line);
    return line;
  }

  line(x1, y1, x2, y2, options) {
    return this.addLine(x1, y1, x2, y2, options);
  }

  remove(element) {
    let removedElement = this.elements.remove(element);
    removedElement.clear();
  }

  removeAll() {
    this.elements.each(el => el.clear());
    this.elements.removeAll();
  }

  getID() {
    return this.id;
  }

  getModel() {
    let properties = {
      plot: this.plot.getModel(),
      elements: []
    };

    this.elements.each(el => properties.elements.push(el.getModel()));
    return properties;
  }

  setModel(model) {
    this.plot.setModel(model.plot, {silent: true});

    if (!this.elements.empty()) {
      this.elements.each((el, i) => el.setModel(model.elements[i], {silent: true}));

    } else {
      model.elements.forEach(el => this[el.model](el));
    }

    this.update();
  }

  getPlot() {
    return this.plot;
  }
}

Plotter.version = '0.2.1';
Plotter.type = null;

window.Plotter = Plotter;
window._ = _;

window.OverContainer = OverContainer;

export default Plotter;