buttons = {}

currState = null
startState = null
leftOrRight = null
leftTicking = null
rightTicking = null
leftPaused = null
rightPaused = null
editor = null

class Button
	constructor : (@text,@x,@y,@w,@h,@bg,@fg) ->
		@enabled = true
	draw : ->
		fill @bg
		rect @x,@y,@w,@h
		fill @fg
		text @text,@x,@y
	inside : -> @x-@w/2 <= mouseX <= @x+@w/2 and @y-@h/2 <= mouseY <= @y+@h/2

class State
	constructor : ->
		@transitions = {}
	getButtons : (names) ->
		result = {}
		for key in names.split ' '
			if key of buttons
				result[key] = buttons[key] 
			else 
				console.log 'missing button:',key
		result
	message : (key) ->
		if key of @transitions 
			transition = @transitions[key]
			currState = transition
		else
			console.log 'missing transition:',key

###################################

class StartState extends State
	constructor : (@name) ->
		super()
		@buttons = @getButtons 'left right play new'
	setTransitions : ->
		@transitions['play'] = leftOrRight
		@transitions['new'] = editor

class LeftOrRight extends State
	constructor : (@name) ->
		super()
		@buttons = @getButtons 'left right pause'
	setTransitions : ->
		@transitions['pause'] = startState
		@transitions['left'] = rightTicking
		@transitions['right'] = leftTicking

class LeftTicking extends State
	constructor : (@name) ->
		super()
		@buttons = @getButtons 'left right pause'
	setTransitions : ->
		@transitions['left'] = rightTicking
		@transitions['pause'] = leftPaused

class RightTicking extends State
	constructor : (@name) ->
		super()
		@buttons = @getButtons 'left right pause'
	setTransitions : ->
		@transitions['right'] = leftTicking
		@transitions['pause'] = rightPaused

class LeftPaused extends State
	constructor : (@name) ->
		super()
		@buttons = @getButtons 'left right play new'
	setTransitions : ->
		@transitions['play'] = leftTicking
		@transitions['new'] = editor

class RightPaused extends State
	constructor : (@name) ->
		super()
		@buttons = @getButtons 'left right play new'
	setTransitions : ->
		@transitions['play'] = rightTicking
		@transitions['new'] = editor

class Editor extends State
	constructor : (@name) ->
		super()
		@buttons = @getButtons 'ok'
	setTransitions : ->
		@transitions['ok'] = startState

setup = ->
	createCanvas 300,300
	background 'black'

	textAlign CENTER,CENTER
	rectMode CENTER

	buttons['left'] =  new Button 'left', 150, 50, 300, 100,'white','black'
	buttons['right'] = new Button 'right',150,250, 300, 100,'red','black'
	buttons['play'] =  new Button 'play', 50, 150, 100, 100,'yellow','black'
	buttons['pause'] = new Button 'pause',50, 150, 100, 100,'green','white'
	buttons['new'] =   new Button 'new',  250,150, 100, 100,'pink','black'
	buttons['ok'] =    new Button 'ok',  150,250, 100, 100,'white','black'

	startState = new StartState 'startState'
	leftOrRight = new LeftOrRight 'leftOrRight'
	editor = new Editor 'Editor'
	leftTicking = new LeftTicking 'leftTicking'
	rightTicking = new RightTicking 'rightTicking'
	leftPaused = new LeftPaused 'leftPaused'
	rightPaused = new RightPaused 'rightPaused'

	startState.setTransitions()
	leftOrRight.setTransitions()
	editor.setTransitions()
	leftTicking.setTransitions()
	rightTicking.setTransitions()
	leftPaused.setTransitions()
	rightPaused.setTransitions()

	currState = startState
	console.log currState

draw = ->
	background 'black'
	fill 'White'
	text currState.name,150,150
	for key of currState.buttons
		if key of buttons
			button = buttons[key]
			button.draw()
		else
			console.log 'missing button:',key

mouseClicked = ->
	for key of currState.buttons
		button = buttons[key]
		if button.inside mouseX, mouseY
			currState.message key
			break
