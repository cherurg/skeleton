import Wrap from './Wrap.coffee';
import ee from 'event-emitter';
import Gate from './Gate.coffee';

class OverContainer extends Wrap {
  constructor(type) {
    super();
    this.type = type;
    this.gate = new Gate(this);
  }

  getModel() {
    this.arr.map(item => item.getModel());
  }

  setModel(modelContainer) {
    modelContainer.forEach((model, i) => {
      this.arr[i].setModel(model);
    });
  }

  add(el) {
    Wrap.prototype.add.call(this, el);
    el.emitter.on('drawn', () => {
      if (overContainer.type === 'sender') {
        this.gate.send();
      }
    });
  }

  getType() {
    return this.type;
  }
}

export default OverContainer;