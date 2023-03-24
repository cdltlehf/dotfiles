const zip = (a, b) => a.map((k, i) => [k, b[i]]);

const iconsBefore = [[], ['&#x21E5'], ['&#x2303'], ['&#x21E7']];
const codesBefore = [[], ['Tab'], ['ControlRight'], ['ShiftLeft']];

const iconsAfter = [['&#x232B'], [], ['&#x23CE'], ['&#x21E7']];
const codesAfter = [['Backspace'], [], ['Enter'], ['ShiftRight']];

const han390 = [
  [
    "\`ㅎㅆㅂㅛㅠㅑㅖㅢㅜㅋ-=".split(''),
    "ㅅㄹㅕㅐㅓㄹㄷㅁㅊㅍ[]\\".split(''),
    "ㅇㄴㅣㅏㅡㄴㅇㄱㅈㅂㅌ".split(''),
    "ㅁㄱㅔㅗㅜㅅㅎ,.ㅗ".split(''),
  ],
  [
    "~ㅈ@#$%^&*()_+".split(''),
    "ㅍㅌㅋㅒ;<789>{}|".split(''),
    "ㄷㄶㄺㄲ/\'456:\"".split(''),
    "ㅊㅄㄻㅀ!0123?".split(''),
  ],
];
const codes = [
  [
    "Backquote",
    ..."1234567890".split('').map((e) => `Digit${e}`),
    "Minus", "Equal",
  ],
  [
    ..."QWERTYUIOP".split('').map((e) => `Key${e}`),
    "BracketLeft", "BracketRight", "Backslash",
  ],
  [
    ..."ASDFGHJKL".split('').map((e) => `Key${e}`),
    "Semicolon", "Quote",
  ],
  [
    ..."ZXCVBNM".split('').map((e) => `Key${e}`),
    "Comma", "Period", "Slash",
  ],
];
const types = [
  [-1, 0, 0, 1, 1, 1, 1, 1, 1, 3, 2, -1, -1],
  [0, 0, 1, 1, 1, 2, 2, 2, 2, 2, -1, -1, -1],
  [0, 0, 1, 1, 1, 2, 2, 2, 2, 2, 2],
  [0, 0, 1, 1, 1, 2, 2, -1, -1, 3],
];
const shiftedTypes = [
  [-1, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
  [0, 0, 0, 1, -1, -1, 4, 4, 4, -1, -1, -1, -1],
  [0, 0, 0, 0, -1, -1, 4, 4, 4, -1, -1],
  [0, 0, 0, 0, -1, 4, 4, 4, 4, -1],
];
const colorMap = [ 'red', 'green', 'cyan', 'purple', 'pink' ];

class Block {
  constructor(label, shiftedLabel=null) {
    this.dom = null;

    this._label = label;
    this._shiftedLabel = shiftedLabel;

    this._color = null;
    this._shiftedColor = null;

    this._initDom();
  }

  shift() {
    if (this._shiftedLabel !== null) {
      this.dom.innerHTML = this._shiftedLabel;
    }
    this._setShiftedColorClass();
  }

  unshift() {
    this.dom.innerHTML = this._label;
    this._setColorClass();
  }

  addColorClass(i, j) {
    this._color = colorMap[types[i][j]];
    this._shiftedColor = colorMap[shiftedTypes[i][j]];

    this._setColorClass();
  }

  addHighlightedClass() {
    this.dom.classList.add('highlighted');
  }

  _initDom() {
    const container = document.createElement('span');
    container.innerHTML = this._label;
    this.dom = container;
  }

  _setColorClass() {
    this.dom.classList.remove(this._shiftedColor);
    this.dom.classList.add(this._color);
  }

  _setShiftedColorClass() {
    this.dom.classList.remove(this._color);
    this.dom.classList.add(this._shiftedColor);
  }
}

function getBlockArray(data, shiftedData=null) {
  return data.map((row, i) => {
    return row.map((item, j) => {
      if (shiftedData !== null) return new Block(item, shiftedData[i][j]);
      else return new Block(item, null);
    })
  });
}

function getBlockMap(code, blocks) {
  return Object.fromEntries(zip(code, blocks));
}

function main() {

  const wrapper = document.createElement('div');
  wrapper.id = "wrapper";

  const blocks = getBlockArray(...han390);
  const blocksBefore = getBlockArray(iconsBefore);
  const blocksAfter = getBlockArray(iconsAfter);

  const blockMap = {
    ...getBlockMap(codes.flat(), blocks.flat()),
    ...getBlockMap(codesBefore.flat(), blocksBefore.flat()),
    ...getBlockMap(codesAfter.flat(), blocksAfter.flat()),
  }

  document.addEventListener('keydown', (event) => {
    event.preventDefault();
    if (blockMap[event.code] !== undefined) {
      blockMap[event.code].dom.classList.add('pressed');
    }
    if (event.key == 'Shift') {
      blocks.forEach(row => row.forEach(e => e.shift()));
    }
  });

  document.addEventListener('keyup', (event) => {
    event.preventDefault();
    if (blockMap[event.code] !== undefined) {
      blockMap[event.code].dom.classList.remove('pressed');
    }
    if (event.key == 'Shift') {
      blocks.forEach(row => row.forEach(e => e.unshift()));
    }
  });

  for (let i in blocks) {
    const row = blocks[i];

    const container = document.createElement('div');
    container.classList.add("row");

    for (let block of blocksBefore[i]) {
      block.dom.classList.add("flexible-block");
      container.append(block.dom);
    }

    for (let j in row) {
      const block = row[j];
      block.dom.classList.add("block");
      block.addColorClass(i, j);

      if (i == 2) {
        if (j == 3 || j == 6) {
          block.addHighlightedClass();
        }
      }
      container.append(block.dom);
    }

    for (let block of blocksAfter[i]) {
      block.dom.classList.add("flexible-block");
      container.append(block.dom);
    }

    wrapper.append(container);
  }

  document.body.append(wrapper);
}

window.onload = main;
