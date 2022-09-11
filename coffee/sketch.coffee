setup = ->
	createCanvas innerWidth,innerHeight

draw = ->
	rect width/4,height/4,width/2,height/2
	textSize 100
	textAlign CENTER,CENTER
	text 'A',width/2,height/2

windowResized = ->
	resizeCanvas innerWidth, innerHeight

mousePressed = ->
	fullscreen true