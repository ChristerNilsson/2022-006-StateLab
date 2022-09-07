HOUR = 3600
MINUTE = 60

buttons = {}
states = {}

timeout = [false,false]

currState = null

class Button
	constructor : (@text,@x,@y,@w,@h,@bg='white',@fg='black') ->
	draw : (disabled) ->
		if disabled then fill 'lightgray' else fill @bg
		rect @x,@y,@w,@h
		textSize 0.04*height
		fill @fg
		text @text,@x,@y
	inside : -> -@w/2 <= mouseX-@x <= @w/2 and -@h/2 <= mouseY-@y <= @h/2

class RotateButton extends Button
	constructor : (x,y,w,h,@degrees,bg,fg,@player) ->
		super '',x,y,w,h,bg,fg

	draw : ->
		secs = states.Editor.clocks[@player]
		if secs == 0 then fill 'gray'
		[h,m,s] = hms Math.trunc secs
		ss = if h >= 1 then d2(h) + ':' + d2(m) else d2(m) + ':' + d2(s)

		fill @bg
		rect @x,@y,@w,@h

		push()
		translate @x,@y
		rotate @degrees
		textSize 0.22*height
		fill @fg
		text ss,0,0.017*height
		textSize 0.05*height
		text '+' + round3(states.Editor.bonuses[@player])+'s',0,90
		if timeout[@player] then text 'Out of time',0,-90
		pop()

class EditButton extends Button
	constructor : (text,x,y,w,h,fg='gray') ->
		super text,x,y,w,h,'black',fg
	draw : ->
		textSize 0.05*height
		fill @fg
		text @text,@x,@y

class DeadButton extends Button
	constructor : (text,x,y,fg='lightgray') ->
		super text,x,y,0,0,'black',fg
	draw : ->
		textSize 0.05*height
		fill @fg
		text @text,@x,@y

class ColorButton extends Button
	constructor : (@fg,x,y) ->
		super '',x,y,0,0
	draw : ->
		push()
		textAlign CENTER,CENTER
		textSize 0.04*height
		fill @fg
		text @text,@x,@y
		pop()

class State
	constructor : -> @transitions = {}
	createTrans : (t) -> 
		arr = t.split ' '
		for pair in arr
			[key,target] = pair.split '=>'
			@transitions[key] = target
	message : (key) ->
		console.log "clicked #{@name}.#{key} => #{@transitions[key]}"
		if key of @transitions
			currState = states[@transitions[key]]
			currState.patch()
		else console.log 'missing transition:',key
	patch : ->
	draw : ->

createState = (key,klass) -> states[key] = new klass key

round3 = (x) -> Math.round(x*1000)/1000

pretty = (tot) ->
	s = tot % 60
	tot = (tot - s) / 60
	m = tot % 60
	tot = (tot - m) / 60
	h = tot % 60
	header = ''
	if h>0 then header += round3(h) + 'h'
	if m>0 then header += round3(m) + 'm'
	if s>0 then header += round3(s) + 's'
	header

d2 = (x) ->
	x = Math.trunc x
	if x < 10 then '0'+x else x
console.log d2(3), '03'

hms = (x) ->
	s = x %% 60
	x = x // 60
	m = x %% 60
	x = x // 60
	h = x
	[h,m,s]
console.log hms(180), [0,3,0]

###################################

class StartState extends State
	constructor : (@name) ->
		super()
		@createTrans 'left right play=>LeftOrRight new=>Editor'

class LeftOrRight extends State
	constructor : (@name) ->
		super()
		@createTrans 'left=>RightTicking right=>LeftTicking pause=>StartState'

class LeftTicking extends State
	constructor : (@name) ->
		super()
		@createTrans 'right left=>RightTicking pause=>LeftPaused'
	draw : ->
		console.log 'LeftTicking'
		if not timeout[0] then states.Editor.clocks[0] -= 1/60
		if states.Editor.clocks[0] <= 0 
			states.Editor.clocks[0] = 0
			timeout[0] = true
			console.log timeout
		buttons.left.fg = 'white'
		buttons.right.fg = 'black'
		super()
	message : (key) ->
		if key == 'left'
			if not timeout[0]
				states.Editor.clocks[0] += states.Editor.bonuses[0]
			buttons.left.fg = 'white'
			buttons.right.fg = 'black'
		super key

class RightTicking extends State
	constructor : (@name) ->
		super()
		@createTrans 'left right=>LeftTicking pause=>RightPaused'
	draw : ->
		console.log 'RightTicking'
		if not timeout[1] then states.Editor.clocks[1] -= 1/60
		if states.Editor.clocks[1] <= 0 
			states.Editor.clocks[1] = 0
			timeout[1] = true
			console.log timeout
		buttons.left.fg = 'black'
		buttons.right.fg = 'white'
		super()
	message : (key) ->
		if key == 'right'
			if not timeout[1]
				states.Editor.clocks[1] += states.Editor.bonuses[1]
			buttons.left.fg = 'black'
			buttons.right.fg = 'white'
		super key

class LeftPaused extends State
	constructor : (@name) ->
		super()
		@createTrans 'left right play=>LeftTicking new=>Editor'

class RightPaused extends State
	constructor : (@name) ->
		super()
		@createTrans 'left right play=>RightTicking new=>Editor'

class Editor extends State
	constructor : (@name) ->
		super()
		@sums = [0,1+2,0,0,2,0]

		@clocks = [3*60,3*60] # seconds
		@bonuses = [2,2] # seconds
		buttons.b0.fg = 'yellow'
		buttons.b1.fg = 'yellow'
		buttons.e1.fg = 'yellow'
		buttons.white.text = '3m + 2s'

		@hcpSwap = 1
		arr = 'red white green reflection bonus hcp ok=>StartState swap=>Editor'.split ' '
		for i in range 6
			letter = 'abcdef'[i]
			arr.push letter
			for j in range 6
				name = letter + j
				arr.push name + '=>Editor'
		@createTrans arr.join ' '
		console.log arr.join ' '

	message : (key) ->
		if key == 'swap'
			@hcpSwap = -@hcpSwap
		if key != 'swap' and key != 'ok'
			buttons[key].fg = if buttons[key].fg == 'gray' then 'yellow' else 'gray'
			letter = key[0]
			i = 'abcdef'.indexOf letter
			j = key[1]
			number = [1,2,4,8,15,30][j]
			@sums[i] = if buttons[key].fg == 'gray' then @sums[i]-number else @sums[i]+number
		if key == 'ok' 
			timeout = [false,false]
			buttons.left.fg = 'black'
			buttons.right.fg = 'black'
		@uppdatera()
		super key

	uppdatera : ->
		buttons.white.text = @compact()
		@handicap()
		if @hcp == 0
			buttons.red.text   = ''
			buttons.green.text = ''
		else
			buttons.red.text   = pretty(@players[0][0]) + ' + ' + pretty(@players[0][1])
			buttons.green.text = pretty(@players[1][0]) + ' + ' + pretty(@players[1][1])

	compact : ->
		headers = 'h m s m s t'.split ' '
		header0 = ''
		header1 = ''
		for i in range 0,3
			if @sums[i]>0 then header0 += @sums[i] + headers[i]
		for i in range 3,5
			if @sums[i]>0 then header1 += @sums[i] + headers[i]
		header = header0
		if header1.length > 0 then header += ' + ' + header1
		header

	handicap : ->
		@hcp = @hcpSwap * @sums[5]/60 # 0.0 .. 1.0
		@refl = HOUR * @sums[0] + MINUTE * @sums[1] + @sums[2] # sekunder
		@bonus =                  MINUTE * @sums[3] + @sums[4] # sekunder
		@players = []
		@players[0] = [@refl*(1+@hcp), @bonus*(1+@hcp)]
		@players[1] = [@refl*(1-@hcp), @bonus*(1-@hcp)]
		@clocks  = [@players[0][0], @players[1][0]]
		@bonuses = [@players[0][1], @players[1][1]]

makeEditButtons = ->
	for i in range 6
		letter = 'abcdef'[i]
		size = 0.13*width
		xoff = size/2 + (width-6*size)/2
		yoff = 0.33*height
		shown='h m s m s t'.split ' '
		buttons[letter] = new DeadButton shown[i], xoff+size*i, 0.26*height 
		for j in range 6
			number = [1,2,4,8,15,30][j]
			name = letter + j
			buttons[name] = new EditButton number, xoff+size*i, yoff+size*j, size, size, 'gray'

setup = ->
	createCanvas screen.width,screen.height
	#createCanvas innerWidth,innerHeight
	#createCanvas 600,900

	background 'black'

	textAlign CENTER,CENTER
	rectMode CENTER
	angleMode DEGREES

	w = width
	h = height

	# Main Page
	buttons.left  = new RotateButton 0.5*w, 0.22*h, w,     0.44*h, 180, 'red',  'black', 0 # eg up
	buttons.right = new RotateButton 0.5*w, 0.78*h, w,     0.44*h,   0, 'green','black', 1 # eg down
	buttons.play  = new Button 'play',  0.2*w, 0.50*h, 0.4*w, 0.12*h
	buttons.pause = new Button 'pause', 0.2*w, 0.50*h, 0.4*w, 0.12*h
	buttons.new   = new Button 'new',   0.8*w, 0.50*h, 0.4*w, 0.12*h
	
	# Edit Page
	buttons.swap  = new Button 'swap', 0.33*w, 0.93*h, 0.14*w, 0.09*h
	buttons.ok    = new Button 'ok',   0.67*w, 0.93*h, 0.14*w, 0.09*h
	buttons.red   = new ColorButton 'red',   w/2, 0.03*h
	buttons.white = new ColorButton 'white', w/2, 0.09*h
	buttons.green = new ColorButton 'green', w/2, 0.15*h
	buttons.reflection = new DeadButton 'reflection', 0.30*w, 0.21*h
	buttons.bonus = new DeadButton 'bonus', 0.63*w, 0.21*h
	buttons.hcp   = new DeadButton 'hcp', 0.83*w, 0.21*h

	makeEditButtons()

	console.log buttons

	createState 'StartState',  StartState
	createState 'LeftOrRight', LeftOrRight
	createState 'Editor',      Editor
	createState 'LeftTicking', LeftTicking
	createState 'RightTicking',RightTicking
	createState 'LeftPaused',  LeftPaused
	createState 'RightPaused', RightPaused

	currState = states.StartState
	console.log 'currState',currState

draw = ->
	background 'black'

	for key of currState.transitions
		target = currState.transitions[key]
		if key of buttons then buttons[key].draw target == undefined
		else console.log 'missing button:',key

	# debug
	# text currState.name,0.5*width,0.03*height
	# fill 'green'
	# text round3(states.Editor.bonuses[0]),0.1*width,0.03*height
	# text round3(states.Editor.clocks[0]),0.25*width,0.03*height
	# text round3(states.Editor.clocks[1]),0.75*width,0.03*height
	# text round3(states.Editor.bonuses[1]),0.9*width,0.03*height
	currState.draw()

mouseClicked = ->
	toggleFullScreen()
	for key of currState.transitions
		if currState.transitions[key] == undefined then continue
		console.log key
		if buttons[key].inside mouseX, mouseY 
			currState.message key
			break
