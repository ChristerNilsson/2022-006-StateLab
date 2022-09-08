HOUR = 3600
MINUTE = 60

buttons = {}
states = {}

qr = null
timeout = [false,false]
currState = null

diag = 0 

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


preload = -> qr = loadImage 'qr.png'

setup = ->
	os = navigator.appVersion
	ok = os.indexOf('Mac') == -1 and os.indexOf('Windows') == -1
	if ok then createCanvas screen.width,screen.height
	else createCanvas innerWidth,innerHeight

	diag = sqrt width*width + height*height

	background 'black'

	textAlign CENTER,CENTER
	rectMode CENTER
	angleMode DEGREES

	w = width
	h = height

	# Main Page
	size = 0.12*h # qr
	buttons.welcome = new Button 'Welcome!', 0.5*w, 0.5*h, 0.5*w, 0.5*h
	buttons.left    = new RotateButton    0.5*w, 0.22*h, w,     0.44*h, 180, 'red',  'black', 0 # eg up
	buttons.right   = new RotateButton    0.5*w, 0.78*h, w,     0.44*h,   0, 'green','black', 1 # eg down
	buttons.play    = new Button 'play',  0.25*(w-size), 0.50*h, (w-size)/2, size
	buttons.pause   = new Button 'pause', 0.25*(w-size), 0.50*h, (w-size)/2, size
	buttons.new     = new Button 'new',   w-0.25*(w-size), 0.50*h, (w-size)/2, size
	buttons.qr      = new ImageButton qr,0.5*w, 0.5*h, size, size
	
	# Edit Page
	buttons.swap  = new Button 'swap', 0.33*w, 0.93*h, 0.20*w, 0.08*h
	buttons.ok    = new Button 'ok',   0.67*w, 0.93*h, 0.20*w, 0.08*h
	buttons.red   = new ColorButton 'red',   w/2, 0.03*h
	buttons.white = new ColorButton 'white', w/2, 0.09*h
	buttons.green = new ColorButton 'green', w/2, 0.15*h
	buttons.reflection = new DeadButton 'reflection', 0.30*w, 0.21*h
	buttons.bonus = new DeadButton 'bonus', 0.63*w, 0.21*h
	buttons.hcp   = new DeadButton 'hcp', 0.83*w, 0.21*h

	makeEditButtons()

	console.log buttons

	createState 'WelcomeState',WelcomeState
	createState 'StartState',  StartState
	createState 'LeftOrRight', LeftOrRight
	createState 'Editor',      Editor
	createState 'LeftTicking', LeftTicking
	createState 'RightTicking',RightTicking
	createState 'LeftPaused',  LeftPaused
	createState 'RightPaused', RightPaused

	currState = states.WelcomeState
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
	for key of currState.transitions
		if currState.transitions[key] == undefined then continue
		console.log key
		if buttons[key].inside mouseX, mouseY 
			currState.message key
			break
