import Wrap from './Wrap.coffee';
import Gate from './Gate.coffee';

class OverContainer extends Wrap {
  static SENDER = 'sender';
  static RECEIVER = 'receiver';

  constructor(type, socket) {
    super();
    this.type = type;
    this.gate = new Gate(this, socket);
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