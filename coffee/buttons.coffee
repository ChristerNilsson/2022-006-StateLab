class Button
	constructor : (@text,@x,@y,@w,@h,@bg='white',@fg='black') ->
	draw : (disabled) ->
		if disabled then fill 'lightgray' else fill @bg
		rect @x,@y,@w,@h
		textSize 0.04*diag
		fill @fg
		text @text,@x,@y
	inside : -> -@w/2 <= mouseX-@x <= @w/2 and -@h/2 <= mouseY-@y <= @h/2

class ImageButton
	constructor : (@image,@x,@y,@w,@h) ->
	draw :  ->
		if @image then image @image,(width-@w)/2,(height-@h)/2,@w,@h
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
		textSize 0.18*diag
		fill @fg
		text ss,0,0.017*height
		textSize 0.05*diag
		text '+' + round3(states.Editor.bonuses[@player])+'s',0,0.15*height
		if timeout[@player] then text 'Out of time',0,-0.15*height
		pop()

class EditButton extends Button
	constructor : (text,x,y,w,h,fg='gray') ->
		super text,x,y,w,h,'black',fg
	draw : ->
		textSize 0.05*diag
		fill @fg
		text @text,@x,@y

class DeadButton extends Button
	constructor : (text,x,y,fg='lightgray') ->
		super text,x,y,0,0,'black',fg
	draw : ->
		textSize 0.04*diag
		fill @fg
		text @text,@x,@y

class ColorButton extends Button
	constructor : (@fg,x,y) ->
		super '',x,y,0,0
	draw : ->
		push()
		textAlign CENTER,CENTER
		textSize 0.04*diag
		fill @fg
		text @text,@x,@y
		pop()
