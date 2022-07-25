-------------------------------------------------------------------------------
--
-- main.lua
--
-- User: mlanca-c
-- URL: http://github.com/mlanca-c/CS50-pong
-- Version: 1.0
-------------------------------------------------------------------------------

-- using push is a library for retro aesthetics
-- https://github.com/Ulydev/push
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()

	love.graphics.setDefaultFilter( 'nearest', 'nearest' )

	-- should be after `setDefaultFilter` otherwise looks weird
	smallFont = love.graphics.newFont( 'font.ttf', 8)

	-- bigger font for keeping score
	scoreFont = love.graphics.newFont( 'font.ttf', 32)

	love.graphics.setFont( smallFont )

	-- replaces love.window.setMode() call
	push:setupScreen( VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})

	math.randomseed( os.time() )
	-- Ball position
	ballX = VIRTUAL_WIDTH / 2 - 2
	ballY = VIRTUAL_HEIGHT / 2 - 2

	-- Ball velocity
	ballDX = math.random( 2 ) == 1 and 100 or -100
	ballDY = math.random( -50, 50 )

	player1Score = 0
	player2Score = 0

	player1Y = 30
	player2Y = VIRTUAL_HEIGHT - 50

	gameState = 'start'
end

--[[
math.randomseed( num )
	Sets num as the "seed" for the pseudo-random generator: equal seeds produce
	equal sequences of numbers.

math.random( min, max )
	returns a random number between min and max.

math.min( num1, num2 )
	returns the minimum value among its arguments.

math.max( num1, num2 )
	returns the maximum value among its arguments.

os.time()
	returns, in seconds, the time since 00:00:00 UTC, January 1, 1970, also
	known as Unix epoch time.
]]

function love.update( dt )

	-- player 1 movement
	if love.keyboard.isDown( 'w' ) then
		player1Y = math.max( 0, player1Y + -PADDLE_SPEED * dt )
	elseif love.keyboard.isDown( 's' ) then
		player1Y = math.min( VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt )
	end

	-- player 2 movement
	if love.keyboard.isDown( 'up' ) then
		player2Y = math.max( 0, player2Y + -PADDLE_SPEED * dt )
	elseif love.keyboard.isDown( 'down' ) then
		player2Y = math.min( VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt )
	end

	if gameState == 'play' then
		ballX = ballX + ballDX * dt
		ballY = ballY + ballDY * dt
	end

end

function love.keypressed( key )

	if key == 'escape' then
		love.event.quit()

	elseif key == 'enter' or key == 'space' then

		if gameState == 'start' then
			gameState = 'play'
		else
			gameState = 'start'

			ballX = VIRTUAL_WIDTH / 2 - 2
			ballY = VIRTUAL_HEIGHT / 2 - 2

			ballDX = math.random( 2 ) == 1 and 100 or -100
			ballDY = math.random( -50, 50 ) * 1.5
		end

	end

end

function love.draw()

	-- begin rendering at virtual resolution
	push:apply( 'start' )

	-- color screen with the original game color instead of black
    love.graphics.clear( 40 / 255, 45 / 255, 52 / 255, 255 / 255 )

	-- now using virtual width and height for text placement
	love.graphics.setFont( smallFont )
	love.graphics.printf(
		'Pong',
		0,
		20,
		VIRTUAL_WIDTH,
		'center'
	)

	-- print game score
	love.graphics.setFont( scoreFont )
	-- player 1 score
	love.graphics.print(
		tostring( player1Score ),
		VIRTUAL_WIDTH / 2 - 50,
		VIRTUAL_HEIGHT / 3
	)
	-- player 2 score
	love.graphics.print(
		tostring( player2Score ),
		VIRTUAL_WIDTH / 2 + 30,
		VIRTUAL_HEIGHT / 3
	)

	-- first paddle (left side)
	love.graphics.rectangle( 'fill', 10, player1Y, 5, 20 )

	-- second paddle (right side)
	love.graphics.rectangle(
		'fill',
		VIRTUAL_WIDTH - 10,
		player2Y,
		5,
		20
	)

	-- ball
	love.graphics.rectangle(
		'fill',
		ballX,
		ballY,
		4,
		4
	)

	-- end rendering at virtual resolution
	push:apply( 'end' )

end
