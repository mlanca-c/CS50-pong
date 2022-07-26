-------------------------------------------------------------------------------
--
-- main.lua
--
-- User: mlanca-c
-- URL: http://github.com/mlanca-c/CS50-pong
-- Version: 1.0
-------------------------------------------------------------------------------

-- class template for a more OOP aproach
Class = require 'class'

-- require Paddle.lua class file
require 'Paddle'

-- require Ball.lua class file
require 'Ball'

-- library used for a more retro looking game
push = require 'push'

-- window dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual dimensions for the push library
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- paddle dimensions
PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20

-- speed of the paddle (arbitrary value)
PADDLE_SPEED = 200

-- ball dimensions
BALL_WIDTH = 4
BALL_HEIGHT = 4

-- maximum player score
MAX_SCORE = 10

-- love.load() it's used to initialize game state at the very beginning.
function love.load()

	-- for random numbers generator
	math.randomseed( os.time() )

	-- window title
	love.window.setTitle( 'Pong Game' )

	-- sets the default scaling filters used with images, canvases, and fonts
	-- (for push library).
	love.graphics.setDefaultFilter( 'nearest', 'nearest' )

	-- initialize fonts
	fonts = {
		-- used for game state messages and FPS message
		['small'] = love.graphics.newFont( 'font.ttf', 8 ),
		-- used for game winning message
		['large'] = love.graphics.newFont( 'font.ttf', 16 ),
		-- used for game score messages
		['score'] = love.graphics.newFont( 'font.ttf', 32 )
	}

	-- initialize sounds
	sounds = {
		-- used when ball hits the paddle
		[ 'paddle_hit' ] = love.audio.newSource( 'sounds/paddle_hit.wav', 'static' ),
		-- used when player scores
		[ 'score' ] = love.audio.newSource( 'sounds/score.wav', 'static' ),
		-- used when ball hits the wall
		[ 'wall_hit' ] = love.audio.newSource( 'sounds/wall_hit.wav', 'static' )
	}

	-- player stats init
	player1Score = 0
	player2Score = 0
	servingPlayer = math.random(2)

	-- paddle init
	paddle1 = Paddle( 10, 30, PADDLE_WIDTH, PADDLE_HEIGHT )
	paddle2 = Paddle( VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50 )

	-- ball init
	ball = Ball( VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2 )

	-- window dimensions setup
	push:setupScreen(
		VIRTUAL_WIDTH,
		VIRTUAL_HEIGHT,
		WINDOW_WIDTH,
		WINDOW_HEIGHT,
		{ fullscreen = false, resizable = true, vsync = true }
	)

	gameState = 'start'

end

-- love.update(dt) updates the state of the game every frame.
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

-- love.draw() is called right after love.update(dt) and draws an image to the
-- window
function love.draw()

	-- drawing starts here
	push:apply( 'start' )

	-- color screen with the original game color instead of black
    love.graphics.clear( 40 / 255, 45 / 255, 52 / 255, 255 / 255 )

	-- display score of the game
	displayScore()

	-- display message according to gameState
	displayGameState()

	-- display paddles
	paddle1:render()
	paddle2:render()

	-- display ball
	ball:render()

	-- display frames pre second
	displayFPS()

	-- drawing stops here
	push:apply( 'end' )

end

-- love.keypressed( key ) is triggered when a key is pressed.
function love.keypressed( key )

	if key == 'escape' then
		love.event.quit()
	end

	if key == 'enter' or key == 'return' then
		if gameState == 'start' then
			gameState = 'serve'
		elseif gameState == 'serve' then
			gameState = 'play'
		elseif gameState == 'done' then

			-- reset ball
			ball:reset()

			-- reset scores
			player1Score = 0
			player2Score = 0

			-- get servingPlayer
			if winningPlayer == 1 then
				servingPlayer = 2
			else
				servingPlayer = 1
			end

			-- restart game
			gameState = 'serve'

		end
	end

end

-- love.resize( w, h ) is called when the window is resized.
function love.resize( w, h )
	-- push library resize function call
	push:resize( w, h )
end

function displayScore()

	love.graphics.setFont( fonts[ 'score' ] )

	-- player1 score
	love.graphics.print(
		tostring( player1Score ),
		VIRTUAL_WIDTH / 2 - 50,
		VIRTUAL_HEIGHT / 3
	)
	-- player2 score
	love.graphics.print(
		tostring( player2Score ),
		VIRTUAL_WIDTH / 2 + 30,
		VIRTUAL_HEIGHT / 3
	)

end

function displayGameState()

	if gameState == 'start' then
		-- start message
		love.graphics.setFont( fonts[ 'small' ] )
		love.graphics.printf(
			'Welcome to pong!',
			0,
			10,
			VIRTUAL_WIDTH,
			'center'
		)
		love.graphics.printf(
			'Press Enter to begin or Esc to leave',
			0,
			20,
			VIRTUAL_WIDTH,
			'center'
		)
	elseif gameState == 'serve' then
		-- serve message
		love.graphics.setFont( fonts[ 'small' ] )
		love.graphics.printf(
			'Player' .. tostring( servingPlayer ) .. "'s serve!",
			0,
			10,
			VIRTUAL_WIDTH,
			'center'
		)
		love.graphics.printf(
			'Press Enter to serve',
			0,
			20,
			VIRTUAL_WIDTH,
			'center'
		)
	elseif gameState == 'done' then
		love.graphics.setFont( fonts[ 'large' ] )
		love.graphics.printf(
			'Player' .. tostring( winningPlayer ) .. " wins!",
			0,
			10,
			VIRTUAL_WIDTH,
			'center'
		)
		love.graphics.printf(
			'Press Enter to restart or Esc to leave',
			0,
			30,
			VIRTUAL_WIDTH,
			'center'
		)
	end

end

-- This function calls love.timer.getFPS() function and displays the FPS on the
-- upper left side of the screen
function displayFPS()

	love.graphics.setFont( fonts[ 'small' ] )
	love.graphics.setColor( 0, 255 / 255, 0, 255 / 255 ) -- green
	love.graphics.print( 'FPS: ' .. tostring( love.timer.getFPS() ) , 20, 20 )

end
