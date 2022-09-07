buttons = {}
states = {}

currState = null

class Button
	constructor : (@text,@x,@y,@w,@h,@bg,@fg) -> @enabled = true
	draw : ->
		fill @bg
		rect @x,@y,@w,@h
		fill @fg
		text @text,@x,@y
	inside : -> -@w/2 <= mouseX-@x <= @w/2 and -@h/2 <= mouseY-@y <= @h/2

class State
	constructor : -> @transitions = {}
	createTrans : (b,s) -> @transitions[b] = s
	message : (key) ->
		if key of @transitions then currState = states[@transitions[key]]
		else console.log 'missing transition:',key

createState = (key,klass) -> states[key] = new klass key

###################################

class StartState extends State
	constructor : (@name) ->
		super()
		@createTrans 'left',  ''            # dead button
		@createTrans 'right', ''            # dead button
		@createTrans 'play',  'LeftOrRight' # active button
		@createTrans 'new',   'Editor'      # active button

class LeftOrRight extends State
	constructor : (@name) ->
		super()
		@createTrans 'left',  'RightTicking'
		@createTrans 'right', 'LeftTicking'
		@createTrans 'pause', 'StartState'

class LeftTicking extends State
	constructor : (@name) ->
		super()
		@createTrans 'left',  'rightTicking'
		@createTrans 'right', ''
		@createTrans 'pause', 'LeftPaused'

class RightTicking extends State
	constructor : (@name) ->
		super()
		@createTrans 'left',  ''
		@createTrans 'right', 'LeftTicking'
		@createTrans 'pause', 'RightPaused'

class LeftPaused extends State
	constructor : (@name) ->
		super()
		@createTrans 'left',  ''
		@createTrans 'right', ''
		@createTrans 'play',  'LeftTicking'
		@createTrans 'new',  'Editor'

class RightPaused extends State
	constructor : (@name) ->
		super()
		@createTrans 'left',  ''
		@createTrans 'right', ''
		@createTrans 'play',  'RightTicking'
		@createTrans 'new',   'Editor'

class Editor extends State
	constructor : (@name) ->
		super()
		@createTrans 'ok', 'StartState'

setup = ->
	createCanvas 300,300
	background 'black'

	textAlign CENTER,CENTER
	rectMode CENTER

	buttons.left  = new Button 'left', 150,  50, 300, 100,'white','black'
	buttons.right = new Button 'right',150, 250, 300, 100,'red','black'
	buttons.play  = new Button 'play',  50, 150, 100, 100,'yellow','black'
	buttons.pause = new Button 'pause', 50, 150, 100, 100,'green','white'
	buttons.new   = new Button 'new',  250, 150, 100, 100,'pink','black'
	buttons.ok    = new Button 'ok',   150, 250, 100, 100,'white','black'

	createState 'StartState',  StartState
	createState 'LeftOrRight', LeftOrRight 
	createState 'Editor',      Editor
	createState 'LeftTicking', LeftTicking
	createState 'RightTicking',RightTicking
	createState 'LeftPaused',  LeftPaused
	createState 'RightPaused', RightPaused

	currState = states.StartState
	console.log currState

draw = ->
	background 'black'
	fill 'White'
	text currState.name,150,150
	for key of currState.transitions
		if key of buttons then buttons[key].draw()
		else console.log 'missing button:',key

mouseClicked = ->
	for key of currState.transitions
		if currState.transitions[key] == '' then continue
		if buttons[key].inside mouseX, mouseY then currState.message key
