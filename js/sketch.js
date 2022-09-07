// Generated by CoffeeScript 2.5.1
var Button, Editor, LeftOrRight, LeftPaused, LeftTicking, RightPaused, RightTicking, StartState, State, buttons, currState, draw, editor, leftOrRight, leftPaused, leftTicking, mouseClicked, rightPaused, rightTicking, setup, startState;

buttons = {};

currState = null;

startState = null;

leftOrRight = null;

leftTicking = null;

rightTicking = null;

leftPaused = null;

rightPaused = null;

editor = null;

Button = class Button {
  constructor(text1, x, y, w, h, bg, fg) {
    this.text = text1;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.bg = bg;
    this.fg = fg;
    this.enabled = true;
  }

  draw() {
    fill(this.bg);
    rect(this.x, this.y, this.w, this.h);
    fill(this.fg);
    return text(this.text, this.x, this.y);
  }

  inside() {
    return (this.x - this.w / 2 <= mouseX && mouseX <= this.x + this.w / 2) && (this.y - this.h / 2 <= mouseY && mouseY <= this.y + this.h / 2);
  }

};

State = class State {
  constructor() {
    this.transitions = {};
  }

  getButtons(names) {
    var i, key, len, ref, result;
    result = {};
    ref = names.split(' ');
    for (i = 0, len = ref.length; i < len; i++) {
      key = ref[i];
      if (key in buttons) {
        result[key] = buttons[key];
      } else {
        console.log('missing button:', key);
      }
    }
    return result;
  }

  message(key) {
    var transition;
    if (key in this.transitions) {
      transition = this.transitions[key];
      return currState = transition;
    } else {
      return console.log('missing transition:', key);
    }
  }

};

//##################################
StartState = class StartState extends State {
  constructor(name) {
    super();
    this.name = name;
    this.buttons = this.getButtons('left right play new');
  }

  setTransitions() {
    this.transitions['play'] = leftOrRight;
    return this.transitions['new'] = editor;
  }

};

LeftOrRight = class LeftOrRight extends State {
  constructor(name) {
    super();
    this.name = name;
    this.buttons = this.getButtons('left right pause');
  }

  setTransitions() {
    this.transitions['pause'] = startState;
    this.transitions['left'] = rightTicking;
    return this.transitions['right'] = leftTicking;
  }

};

LeftTicking = class LeftTicking extends State {
  constructor(name) {
    super();
    this.name = name;
    this.buttons = this.getButtons('left right pause');
  }

  setTransitions() {
    this.transitions['left'] = rightTicking;
    return this.transitions['pause'] = leftPaused;
  }

};

RightTicking = class RightTicking extends State {
  constructor(name) {
    super();
    this.name = name;
    this.buttons = this.getButtons('left right pause');
  }

  setTransitions() {
    this.transitions['right'] = leftTicking;
    return this.transitions['pause'] = rightPaused;
  }

};

LeftPaused = class LeftPaused extends State {
  constructor(name) {
    super();
    this.name = name;
    this.buttons = this.getButtons('left right play new');
  }

  setTransitions() {
    this.transitions['play'] = leftTicking;
    return this.transitions['new'] = editor;
  }

};

RightPaused = class RightPaused extends State {
  constructor(name) {
    super();
    this.name = name;
    this.buttons = this.getButtons('left right play new');
  }

  setTransitions() {
    this.transitions['play'] = rightTicking;
    return this.transitions['new'] = editor;
  }

};

Editor = class Editor extends State {
  constructor(name) {
    super();
    this.name = name;
    this.buttons = this.getButtons('ok');
  }

  setTransitions() {
    return this.transitions['ok'] = startState;
  }

};

setup = function() {
  createCanvas(300, 300);
  background('black');
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  buttons['left'] = new Button('left', 150, 50, 300, 100, 'white', 'black');
  buttons['right'] = new Button('right', 150, 250, 300, 100, 'red', 'black');
  buttons['play'] = new Button('play', 50, 150, 100, 100, 'yellow', 'black');
  buttons['pause'] = new Button('pause', 50, 150, 100, 100, 'green', 'white');
  buttons['new'] = new Button('new', 250, 150, 100, 100, 'pink', 'black');
  buttons['ok'] = new Button('ok', 150, 250, 100, 100, 'white', 'black');
  startState = new StartState('startState');
  leftOrRight = new LeftOrRight('leftOrRight');
  editor = new Editor('Editor');
  leftTicking = new LeftTicking('leftTicking');
  rightTicking = new RightTicking('rightTicking');
  leftPaused = new LeftPaused('leftPaused');
  rightPaused = new RightPaused('rightPaused');
  startState.setTransitions();
  leftOrRight.setTransitions();
  editor.setTransitions();
  leftTicking.setTransitions();
  rightTicking.setTransitions();
  leftPaused.setTransitions();
  rightPaused.setTransitions();
  currState = startState;
  return console.log(currState);
};

draw = function() {
  var button, key, results;
  background('black');
  fill('White');
  text(currState.name, 150, 150);
  results = [];
  for (key in currState.buttons) {
    if (key in buttons) {
      button = buttons[key];
      results.push(button.draw());
    } else {
      results.push(console.log('missing button:', key));
    }
  }
  return results;
};

mouseClicked = function() {
  var button, key, results;
  results = [];
  for (key in currState.buttons) {
    button = buttons[key];
    if (button.inside(mouseX, mouseY)) {
      currState.message(key);
      break;
    } else {
      results.push(void 0);
    }
  }
  return results;
};

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic2tldGNoLmpzIiwic291cmNlUm9vdCI6Ii4uIiwic291cmNlcyI6WyJjb2ZmZWVcXHNrZXRjaC5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBLElBQUEsTUFBQSxFQUFBLE1BQUEsRUFBQSxXQUFBLEVBQUEsVUFBQSxFQUFBLFdBQUEsRUFBQSxXQUFBLEVBQUEsWUFBQSxFQUFBLFVBQUEsRUFBQSxLQUFBLEVBQUEsT0FBQSxFQUFBLFNBQUEsRUFBQSxJQUFBLEVBQUEsTUFBQSxFQUFBLFdBQUEsRUFBQSxVQUFBLEVBQUEsV0FBQSxFQUFBLFlBQUEsRUFBQSxXQUFBLEVBQUEsWUFBQSxFQUFBLEtBQUEsRUFBQTs7QUFBQSxPQUFBLEdBQVUsQ0FBQTs7QUFFVixTQUFBLEdBQVk7O0FBQ1osVUFBQSxHQUFhOztBQUNiLFdBQUEsR0FBYzs7QUFDZCxXQUFBLEdBQWM7O0FBQ2QsWUFBQSxHQUFlOztBQUNmLFVBQUEsR0FBYTs7QUFDYixXQUFBLEdBQWM7O0FBQ2QsTUFBQSxHQUFTOztBQUVILFNBQU4sTUFBQSxPQUFBO0VBQ0MsV0FBYyxNQUFBLEdBQUEsR0FBQSxHQUFBLEdBQUEsSUFBQSxJQUFBLENBQUE7SUFBQyxJQUFDLENBQUE7SUFBSyxJQUFDLENBQUE7SUFBRSxJQUFDLENBQUE7SUFBRSxJQUFDLENBQUE7SUFBRSxJQUFDLENBQUE7SUFBRSxJQUFDLENBQUE7SUFBRyxJQUFDLENBQUE7SUFDckMsSUFBQyxDQUFBLE9BQUQsR0FBVztFQURFOztFQUVkLElBQU8sQ0FBQSxDQUFBO0lBQ04sSUFBQSxDQUFLLElBQUMsQ0FBQSxFQUFOO0lBQ0EsSUFBQSxDQUFLLElBQUMsQ0FBQSxDQUFOLEVBQVEsSUFBQyxDQUFBLENBQVQsRUFBVyxJQUFDLENBQUEsQ0FBWixFQUFjLElBQUMsQ0FBQSxDQUFmO0lBQ0EsSUFBQSxDQUFLLElBQUMsQ0FBQSxFQUFOO1dBQ0EsSUFBQSxDQUFLLElBQUMsQ0FBQSxJQUFOLEVBQVcsSUFBQyxDQUFBLENBQVosRUFB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OztBQURjIiwic291cmNlc0NvbnRlbnQiOlsiYnV0dG9ucyA9IHt9XHJcblxyXG5jdXJyU3RhdGUgPSBudWxsXHJcbnN0YXJ0U3RhdGUgPSBudWxsXHJcbmxlZnRPclJpZ2h0ID0gbnVsbFxyXG5sZWZ0VGlja2luZyA9IG51bGxcclxucmlnaHRUaWNraW5nID0gbnVsbFxyXG5sZWZ0UGF1c2VkID0gbnVsbFxyXG5yaWdodFBhdXNlZCA9IG51bGxcclxuZWRpdG9yID0gbnVsbFxyXG5cclxuY2xhc3MgQnV0dG9uXHJcblx0Y29uc3RydWN0b3IgOiAoQHRleHQsQHgsQHksQHcsQGgsQGJnLEBmZykgLT5cclxuXHRcdEBlbmFibGVkID0gdHJ1ZVxyXG5cdGRyYXcgOiAtPlxyXG5cdFx0ZmlsbCBAYmdcclxuXHRcdHJlY3QgQHgsQHksQHcsQGhcclxuXHRcdGZpbGwgQGZnXHJcblx0XHR0ZXh0IEB0ZXh0LEB4LEB5XHJcblx0aW5zaWRlIDogLT4gQHgtQHcvMiA8PSBtb3VzZVggPD0gQHgrQHcvMiBhbmQgQHktQGgvMiA8PSBtb3VzZVkgPD0gQHkrQGgvMlxyXG5cclxuY2xhc3MgU3RhdGVcclxuXHRjb25zdHJ1Y3RvciA6IC0+XHJcblx0XHRAdHJhbnNpdGlvbnMgPSB7fVxyXG5cdGdldEJ1dHRvbnMgOiAobmFtZXMpIC0+XHJcblx0XHRyZXN1bHQgPSB7fVxyXG5cdFx0Zm9yIGtleSBpbiBuYW1lcy5zcGxpdCAnICdcclxuXHRcdFx0aWYga2V5IG9mIGJ1dHRvbnNcclxuXHRcdFx0XHRyZXN1bHRba2V5XSA9IGJ1dHRvbnNba2V5XSBcclxuXHRcdFx0ZWxzZSBcclxuXHRcdFx0XHRjb25zb2xlLmxvZyAnbWlzc2luZyBidXR0b246JyxrZXlcclxuXHRcdHJlc3VsdFxyXG5cdG1lc3NhZ2UgOiAoa2V5KSAtPlxyXG5cdFx0aWYga2V5IG9mIEB0cmFuc2l0aW9ucyBcclxuXHRcdFx0dHJhbnNpdGlvbiA9IEB0cmFuc2l0aW9uc1trZXldXHJcblx0XHRcdGN1cnJTdGF0ZSA9IHRyYW5zaXRpb25cclxuXHRcdGVsc2VcclxuXHRcdFx0Y29uc29sZS5sb2cgJ21pc3NpbmcgdHJhbnNpdGlvbjonLGtleVxyXG5cclxuIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyNcclxuXHJcbmNsYXNzIFN0YXJ0U3RhdGUgZXh0ZW5kcyBTdGF0ZVxyXG5cdGNvbnN0cnVjdG9yIDogKEBuYW1lKSAtPlxyXG5cdFx0c3VwZXIoKVxyXG5cdFx0QGJ1dHRvbnMgPSBAZ2V0QnV0dG9ucyAnbGVmdCByaWdodCBwbGF5IG5ldydcclxuXHRzZXRUcmFuc2l0aW9ucyA6IC0+XHJcblx0XHRAdHJhbnNpdGlvbnNbJ3BsYXknXSA9IGxlZnRPclJpZ2h0XHJcblx0XHRAdHJhbnNpdGlvbnNbJ25ldyddID0gZWRpdG9yXHJcblxyXG5jbGFzcyBMZWZ0T3JSaWdodCBleHRlbmRzIFN0YXRlXHJcblx0Y29uc3RydWN0b3IgOiAoQG5hbWUpIC0+XHJcblx0XHRzdXBlcigpXHJcblx0XHRAYnV0dG9ucyA9IEBnZXRCdXR0b25zICdsZWZ0IHJpZ2h0IHBhdXNlJ1xyXG5cdHNldFRyYW5zaXRpb25zIDogLT5cclxuXHRcdEB0cmFuc2l0aW9uc1sncGF1c2UnXSA9IHN0YXJ0U3RhdGVcclxuXHRcdEB0cmFuc2l0aW9uc1snbGVmdCddID0gcmlnaHRUaWNraW5nXHJcblx0XHRAdHJhbnNpdGlvbnNbJ3JpZ2h0J10gPSBsZWZ0VGlja2luZ1xyXG5cclxuY2xhc3MgTGVmdFRpY2tpbmcgZXh0ZW5kcyBTdGF0ZVxyXG5cdGNvbnN0cnVjdG9yIDogKEBuYW1lKSAtPlxyXG5cdFx0c3VwZXIoKVxyXG5cdFx0QGJ1dHRvbnMgPSBAZ2V0QnV0dG9ucyAnbGVmdCByaWdodCBwYXVzZSdcclxuXHRzZXRUcmFuc2l0aW9ucyA6IC0+XHJcblx0XHRAdHJhbnNpdGlvbnNbJ2xlZnQnXSA9IHJpZ2h0VGlja2luZ1xyXG5cdFx0QHRyYW5zaXRpb25zWydwYXVzZSddID0gbGVmdFBhdXNlZFxyXG5cclxuY2xhc3MgUmlnaHRUaWNraW5nIGV4dGVuZHMgU3RhdGVcclxuXHRjb25zdHJ1Y3RvciA6IChAbmFtZSkgLT5cclxuXHRcdHN1cGVyKClcclxuXHRcdEBidXR0b25zID0gQGdldEJ1dHRvbnMgJ2xlZnQgcmlnaHQgcGF1c2UnXHJcblx0c2V0VHJhbnNpdGlvbnMgOiAtPlxyXG5cdFx0QHRyYW5zaXRpb25zWydyaWdodCddID0gbGVmdFRpY2tpbmdcclxuXHRcdEB0cmFuc2l0aW9uc1sncGF1c2UnXSA9IHJpZ2h0UGF1c2VkXHJcblxyXG5jbGFzcyBMZWZ0UGF1c2VkIGV4dGVuZHMgU3RhdGVcclxuXHRjb25zdHJ1Y3RvciA6IChAbmFtZSkgLT5cclxuXHRcdHN1cGVyKClcclxuXHRcdEBidXR0b25zID0gQGdldEJ1dHRvbnMgJ2xlZnQgcmlnaHQgcGxheSBuZXcnXHJcblx0c2V0VHJhbnNpdGlvbnMgOiAtPlxyXG5cdFx0QHRyYW5zaXRpb25zWydwbGF5J10gPSBsZWZ0VGlja2luZ1xyXG5cdFx0QHRyYW5zaXRpb25zWyduZXcnXSA9IGVkaXRvclxyXG5cclxuY2xhc3MgUmlnaHRQYXVzZWQgZXh0ZW5kcyBTdGF0ZVxyXG5cdGNvbnN0cnVjdG9yIDogKEBuYW1lKSAtPlxyXG5cdFx0c3VwZXIoKVxyXG5cdFx0QGJ1dHRvbnMgPSBAZ2V0QnV0dG9ucyAnbGVmdCByaWdodCBwbGF5IG5ldydcclxuXHRzZXRUcmFuc2l0aW9ucyA6IC0+XHJcblx0XHRAdHJhbnNpdGlvbnNbJ3BsYXknXSA9IHJpZ2h0VGlja2luZ1xyXG5cdFx0QHRyYW5zaXRpb25zWyduZXcnXSA9IGVkaXRvclxyXG5cclxuY2xhc3MgRWRpdG9yIGV4dGVuZHMgU3RhdGVcclxuXHRjb25zdHJ1Y3RvciA6IChAbmFtZSkgLT5cclxuXHRcdHN1cGVyKClcclxuXHRcdEBidXR0b25zID0gQGdldEJ1dHRvbnMgJ29rJ1xyXG5cdHNldFRyYW5zaXRpb25zIDogLT5cclxuXHRcdEB0cmFuc2l0aW9uc1snb2snXSA9IHN0YXJ0U3RhdGVcclxuXHJcbnNldHVwID0gLT5cclxuXHRjcmVhdGVDYW52YXMgMzAwLDMwMFxyXG5cdGJhY2tncm91bmQgJ2JsYWNrJ1xyXG5cclxuXHR0ZXh0QWxpZ24gQ0VOVEVSLENFTlRFUlxyXG5cdHJlY3RNb2RlIENFTlRFUlxyXG5cclxuXHRidXR0b25zWydsZWZ0J10gPSAgbmV3IEJ1dHRvbiAnbGVmdCcsIDE1MCwgNTAsIDMwMCwgMTAwLCd3aGl0ZScsJ2JsYWNrJ1xyXG5cdGJ1dHRvbnNbJ3JpZ2h0J10gPSBuZXcgQnV0dG9uICdyaWdodCcsMTUwLDI1MCwgMzAwLCAxMDAsJ3JlZCcsJ2JsYWNrJ1xyXG5cdGJ1dHRvbnNbJ3BsYXknXSA9ICBuZXcgQnV0dG9uICdwbGF5JywgNTAsIDE1MCwgMTAwLCAxMDAsJ3llbGxvdycsJ2JsYWNrJ1xyXG5cdGJ1dHRvbnNbJ3BhdXNlJ10gPSBuZXcgQnV0dG9uICdwYXVzZScsNTAsIDE1MCwgMTAwLCAxMDAsJ2dyZWVuJywnd2hpdGUnXHJcblx0YnV0dG9uc1snbmV3J10gPSAgIG5ldyBCdXR0b24gJ25ldycsICAyNTAsMTUwLCAxMDAsIDEwMCwncGluaycsJ2JsYWNrJ1xyXG5cdGJ1dHRvbnNbJ29rJ10gPSAgICBuZXcgQnV0dG9uICdvaycsICAxNTAsMjUwLCAxMDAsIDEwMCwnd2hpdGUnLCdibGFjaydcclxuXHJcblx0c3RhcnRTdGF0ZSA9IG5ldyBTdGFydFN0YXRlICdzdGFydFN0YXRlJ1xyXG5cdGxlZnRPclJpZ2h0ID0gbmV3IExlZnRPclJpZ2h0ICdsZWZ0T3JSaWdodCdcclxuXHRlZGl0b3IgPSBuZXcgRWRpdG9yICdFZGl0b3InXHJcblx0bGVmdFRpY2tpbmcgPSBuZXcgTGVmdFRpY2tpbmcgJ2xlZnRUaWNraW5nJ1xyXG5cdHJpZ2h0VGlja2luZyA9IG5ldyBSaWdodFRpY2tpbmcgJ3JpZ2h0VGlja2luZydcclxuXHRsZWZ0UGF1c2VkID0gbmV3IExlZnRQYXVzZWQgJ2xlZnRQYXVzZWQnXHJcblx0cmlnaHRQYXVzZWQgPSBuZXcgUmlnaHRQYXVzZWQgJ3JpZ2h0UGF1c2VkJ1xyXG5cclxuXHRzdGFydFN0YXRlLnNldFRyYW5zaXRpb25zKClcclxuXHRsZWZ0T3JSaWdodC5zZXRUcmFuc2l0aW9ucygpXHJcblx0ZWRpdG9yLnNldFRyYW5zaXRpb25zKClcclxuXHRsZWZ0VGlja2luZy5zZXRUcmFuc2l0aW9ucygpXHJcblx0cmlnaHRUaWNraW5nLnNldFRyYW5zaXRpb25zKClcclxuXHRsZWZ0UGF1c2VkLnNldFRyYW5zaXRpb25zKClcclxuXHRyaWdodFBhdXNlZC5zZXRUcmFuc2l0aW9ucygpXHJcblxyXG5cdGN1cnJTdGF0ZSA9IHN0YXJ0U3RhdGVcclxuXHRjb25zb2xlLmxvZyBjdXJyU3RhdGVcclxuXHJcbmRyYXcgPSAtPlxyXG5cdGJhY2tncm91bmQgJ2JsYWNrJ1xyXG5cdGZpbGwgJ1doaXRlJ1xyXG5cdHRleHQgY3VyclN0YXRlLm5hbWUsMTUwLDE1MFxyXG5cdGZvciBrZXkgb2YgY3VyclN0YXRlLmJ1dHRvbnNcclxuXHRcdGlmIGtleSBvZiBidXR0b25zXHJcblx0XHRcdGJ1dHRvbiA9IGJ1dHRvbnNba2V5XVxyXG5cdFx0XHRidXR0b24uZHJhdygpXHJcblx0XHRlbHNlXHJcblx0XHRcdGNvbnNvbGUubG9nICdtaXNzaW5nIGJ1dHRvbjonLGtleVxyXG5cclxubW91c2VDbGlja2VkID0gLT5cclxuXHRmb3Iga2V5IG9mIGN1cnJTdGF0ZS5idXR0b25zXHJcblx0XHRidXR0b24gPSBidXR0b25zW2tleV1cclxuXHRcdGlmIGJ1dHRvbi5pbnNpZGUgbW91c2VYLCBtb3VzZVlcclxuXHRcdFx0Y3VyclN0YXRlLm1lc3NhZ2Uga2V5XHJcblx0XHRcdGJyZWFrXHJcbiJdfQ==
//# sourceURL=c:\github\2022-006-StateLab\coffee\sketch.coffee