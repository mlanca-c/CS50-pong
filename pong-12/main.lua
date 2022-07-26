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

-- class library for oop
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- Ball class
require 'Ball'

-- Paddle class
require 'Paddle'

-- window dimension
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
MAX_SCORE = 10

--[[
love.resize( width, height )
	Called when the window is resized, for example if the user resizes the
	window, or if love.window.setMode is called with an unsupported width or
	height in fullscreen and the window chooses the closest appropriate size.
]]

function love.load()

	-- sets window title
	love.window.setTitle( 'Pong' )

	love.graphics.setDefaultFilter( 'nearest', 'nearest' )

	-- should be after `setDefaultFilter` otherwise looks weird
	smallFont = love.graphics.newFont( 'font.ttf', 8)
	-- large font for announcing winner
	largeFont = love.graphics.newFont( 'font.ttf', 16)
	-- bigger font for keeping score
	scoreFont = love.graphics.newFont( 'font.ttf', 32)

	love.graphics.setFont( smallFont )

	-- sound effects
	sounds = {
		[ 'paddle_hit' ] = love.audio.newSource( 'sounds/paddle_hit.wav', 'static' ),
		[ 'score' ] = love.audio.newSource( 'sounds/score.wav', 'static' ),
		[ 'wall_hit' ] = love.audio.newSource( 'sounds/wall_hit.wav', 'static' )
	}

	-- replaces love.window.setMode() call
	push:setupScreen( VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = true,
		vsync = true
	})

	-- Initializing score values
	player1Score = 0
	player2Score = 0

	-- player thats serving in the following turn
	servingPlayer = 1

	math.randomseed( os.time() )

	-- init paddle instances
	paddle1 = Paddle( 10, 30, 5, 20 )
	paddle2 = Paddle( VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20 )

	-- init ball instance
	ball = Ball( VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4 )

	gameState = 'start'

end

function love.update( dt )

	-- ball movement
	if gameState == 'serve' then

		ball.dy = math.random( -50, 50 )

		if servingPlayer == 1 then
			ball.dx = math.random( 140, 200 )
		else
			ball.dx = -math.random( 140, 200 )
		end

	elseif gameState == 'play' then

		-- detect collision with paddle1
		if ball:collides( paddle1 ) then

			ball.dx = -ball.dx * 1.03
			ball.x = paddle1.x + 5

			if ball.dy < 0 then
				ball.dy = -math.random( 10, 150 )
			else
				ball.dy = math.random( 10, 150 )
			end
			sounds[ 'paddle_hit' ]:play()
		end

		-- detect collision with paddle2
		if ball:collides( paddle2 ) then

			ball.dx = -ball.dx * 1.03
			ball.x = paddle2.x - 4

			if ball.dy < 0 then
				ball.dy = -math.random( 10, 150 )
			else
				ball.dy = math.random( 10, 150 )
			end
			sounds[ 'paddle_hit' ]:play()
		end

		-- detect collision with upper and lower screen boundaries
		if ball.y <= 0 then
			ball.y = 0
			ball.dy = -ball.dy
			sounds[ 'wall_hit' ]:play()
		end

		if ball.y >= VIRTUAL_HEIGHT - 4 then
			ball.y = VIRTUAL_HEIGHT - 4
			ball.dy = -ball.dy
			sounds[ 'wall_hit' ]:play()
		end
	end

	-- player1 scoring
	if ball.x > VIRTUAL_WIDTH and gameState == 'play' then

		servingPlayer = 2
		player1Score = player1Score + 1
		sounds[ 'score' ]:play()

		-- player1 winning
		if player1Score >= MAX_SCORE then
			gameState = 'done'
			winningPlayer = 1
		else
			gameState = 'serve'
			ball:reset()
		end
	end

	-- player2 scoring
	if ball.x < 0 and gameState == 'play' then

		servingPlayer = 1
		player2Score = player2Score + 1
		sounds[ 'score' ]:play()

		-- player2 winning
		if player2Score >= MAX_SCORE then
			gameState = 'done'
			winningPlayer = 2
		else
			gameState = 'serve'
			ball:reset()
		end
	end

	-- player 1 movement
	if love.keyboard.isDown( 'w' ) then
		paddle1.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown( 's' ) then
		paddle1.dy = PADDLE_SPEED
	else
		paddle1.dy = 0
	end

	-- player 2 movement
	if love.keyboard.isDown( 'up' ) then
		paddle2.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown( 'down' ) then
		paddle2.dy = PADDLE_SPEED
	else
		paddle2.dy = 0
	end

	-- ball update
	if gameState == 'play' then
		ball:update( dt )
	end

	-- paddles update
	paddle1:update( dt )
	paddle2:update( dt )

end

function love.keypressed( key )

	if key == 'escape' then
		love.event.quit()
	elseif key == 'enter' or key == 'return' then

		if gameState == 'start' then
			gameState = 'serve'
		elseif gameState == 'serve' then
			gameState = 'play'
		elseif gameState == 'done' then

			gameState = 'serve'
			ball:reset()

			-- reset scores
			player1Score = 0
			player2Score = 0

			if winningPlayer == 1 then
				servingPlayer = 2
			else
				servingPlayer = 1
			end
		end
	end
end

function love.draw()

	-- begin rendering at virtual resolution
	push:apply( 'start' )

	-- color screen with the original game color instead of black
    love.graphics.clear( 40 / 255, 45 / 255, 52 / 255, 255 / 255 )

	love.graphics.setFont( smallFont )

	-- display score funtion call
	displayScore()

	-- now using virtual width and height for text placement
	if gameState == 'start' then
		love.graphics.setFont( smallFont )
		love.graphics.printf( 'Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center' )
		love.graphics.printf( 'Press enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center' )
	elseif gameState == 'serve' then
		love.graphics.setFont( smallFont )
		love.graphics.printf( 'Player' .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center' )
		love.graphics.printf( 'Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center' )
	elseif gameState == 'done' then
		love.graphics.setFont( largeFont )
		love.graphics.printf( 'Player' .. tostring(winningPlayer) ..' wins!', 0, 10, VIRTUAL_WIDTH, 'center' )
		love.graphics.setFont( smallFont )
		love.graphics.printf( 'Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center' )
	end

	-- first paddle (left side)
	paddle1:render()
	-- second paddle (right side)
	paddle2:render()
	-- ball
	ball:render()

	-- display FPS funtion call
	displayFPS()
	displayGameState()

	-- end rendering at virtual resolution
	push:apply( 'end' )

end

-- renders the current FPS
function displayFPS()

	-- print game score
	love.graphics.setFont( smallFont )

	-- green color
	love.graphics.setColor( 0, 255 / 255, 0, 255 / 255 )
	love.graphics.print( 'FPS: ' .. tostring( love.timer.getFPS() ), 10, 10 )

end

-- renders the score
function displayScore()

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

end

function displayGameState()

	-- print game score
	love.graphics.setFont( smallFont )
	love.graphics.setColor( 0, 255 / 255, 0, 255 / 255 )
	love.graphics.print(
		'game state: ' .. gameState,
		20,
		20
	)

end

function love.resize( w, h )
	push:resize( w, h )
end
