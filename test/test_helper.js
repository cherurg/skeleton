import jsdom from 'jsdom';
import 'coffee-script/register';

const doc = jsdom.jsdom(`
<!doctype html>
<html>
<body>
  <div id="plot-container"></div>
</body>
</html>`);
const win = doc.defaultView;

global.document = doc;
global.window = win;

// from mocha-jsdom https://github.com/rstacruz/mocha-jsdom/blob/master/index.js#L80
Object.keys(window).forEach((key) => {
  if (!(key in global)) {
    global[key] = window[key];
  }
});

export function isNode(o){
  return (
    typeof Node === "object" ? o instanceof Node :
    o && typeof o === "object" && typeof o.nodeType === "number" && typeof o.nodeName==="string"
  );
}

//Returns true if it is a DOM element
export function isElement(o){
  return (
    typeof HTMLElement === "object" ? o instanceof HTMLElement : //DOM2
    o && typeof o === "object" && o !== null && o.nodeType === 1 && typeof o.nodeName==="string"
  );
}