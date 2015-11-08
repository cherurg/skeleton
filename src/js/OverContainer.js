import Wrap from './Wrap.coffee';
import ee from 'event-emitter';
import Gate from './Gate.coffee';

class OverContainer extends Wrap {
  static SENDER = 'sender';
  static RECEIVER = 'receiver';

  constructor(type) {
    super();
    this.type = type;
    this.gate = new Gate(this);
  }

  getModel() {
    return this.arr.map(item => item.getModel());
  }

  setModel(modelContainer) {
    return modelContainer.forEach((model, i) => {
      this.arr[i].setModel(model);
    });
  }

  add(el) {
    Wrap.prototype.add.call(this, el);
    return el.emitter.on('drawn', () => {
      if (overContainer.type === OverContainer.SENDER) {
        this.gate.send();
      }
    });
  }

  getType() {
    return this.type;
  }

  getGate() {
    return this.gate;
  }
}

export default OverContainer;