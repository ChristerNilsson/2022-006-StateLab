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

class WelcomeState extends State
	constructor : (@name) ->
		super()
		@createTrans 'welcome=>StartState'
	message : (key) ->
		if key == 'welcome'
			os = navigator.appVersion
			ok = os.indexOf('Mac') == -1 and os.indexOf('Windows') == -1
			console.log ok
			if ok then toggleFullScreen()
		super key

class StartState extends State
	constructor : (@name) ->
		super()
		@createTrans 'qr left right play=>LeftOrRight new=>Editor'

class LeftOrRight extends State
	constructor : (@name) ->
		super()
		@createTrans 'qr left=>RightTicking right=>LeftTicking pause=>StartState'
	draw : ->
		buttons.left.fg = 'white'
		buttons.right.fg = 'white'

class LeftTicking extends State
	constructor : (@name) ->
		super()
		@createTrans 'qr right left=>RightTicking pause=>LeftPaused'
	draw : ->
		if not timeout[0] then states.Editor.clocks[0] -= 1/60
		if states.Editor.clocks[0] <= 0 
			states.Editor.clocks[0] = 0
			timeout[0] = true
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
		@createTrans 'qr left right=>LeftTicking pause=>RightPaused'
	draw : ->
		if not timeout[1] then states.Editor.clocks[1] -= 1/60
		if states.Editor.clocks[1] <= 0 
			states.Editor.clocks[1] = 0
			timeout[1] = true
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
		@createTrans 'qr left right play=>LeftTicking new=>Editor'

class RightPaused extends State
	constructor : (@name) ->
		super()
		@createTrans 'qr left right play=>RightTicking new=>Editor'

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
