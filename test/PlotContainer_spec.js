import {PlotContainer} from '../src/js/PlotContainer';
import Wrap from '../src/js/Wrap.coffee';
import {expect} from 'chai';
import {isNode, isElement} from './test_helper.js';

let plotContainerId = 'plot-container';

describe('PlotContainer', () => {
  afterEach(() => {
    document.getElementById(plotContainerId).innerHTML = "";
  });

  describe('constructor', () => {
    it('constructs an object', () => {
      let c = new PlotContainer(plotContainerId);
      expect(c).to.be.an('object');
    });
  });

  describe('getAttrs', () => {
    it('returns an object', () => {
      let c = new PlotContainer(plotContainerId);
      expect(c.getAttrs()).to.be.an('object');
    });
  });

  describe('getId', () => {
    it('returns ID', () => {
      let c = new PlotContainer(plotContainerId);
      expect(c.getId()).to.equal(plotContainerId);
    });
  });

  describe('addEmptyDiv', () => {
    it('returns an id of the created element', () => {
      let c = new PlotContainer(plotContainerId);
      let newDivId = c.addEmptyDiv();
      expect(newDivId).to.be.a('string');
    });

    it('return id of a new element WITHOUT # at newDivId[0]', () => {
      let c = new PlotContainer(plotContainerId);
      let newDivId = c.addEmptyDiv();
      expect(newDivId[0]).to.not.equal('#');
    });

    it('adds the new element to the dom tree', () => {
      let c = new PlotContainer(plotContainerId);
      let newDivId = c.addEmptyDiv();
      expect(document.getElementById(newDivId).id).to.equal(newDivId);
    });

    it('increments plotters number', () => {
      let c = new PlotContainer(plotContainerId);
      expect(c.getPlottersNumber()).to.equal(0);
      c.addEmptyDiv();
      expect(c.getPlottersNumber()).to.equal(1);
    });
  });

  describe('getPlotters', () => {
    it('returns a Wrap', () => {
      let c = new PlotContainer(plotContainerId);
      expect(c.getPlotters() instanceof Wrap).to.equal(true);
    });
  });
});