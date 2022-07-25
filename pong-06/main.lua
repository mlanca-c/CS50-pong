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

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()

	-- sets window title
	love.window.setTitle( 'Pong' )

	love.graphics.setDefaultFilter( 'nearest', 'nearest' )

	-- should be after `setDefaultFilter` otherwise looks weird
	smallFont = love.graphics.newFont( 'font.ttf', 8)

	love.graphics.setFont( smallFont )

	-- bigger font for keeping score
	scoreFont = love.graphics.newFont( 'font.ttf', 32)

	-- replaces love.window.setMode() call
	push:setupScreen( VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})

	math.randomseed( os.time() )

	-- init paddle instances
	paddle1 = Paddle( 10, 30, 5, 20 )
	paddle2 = Paddle( VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20 )

	-- init ball instance
	ball = Ball( VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4 )

	player1Score = 0
	player2Score = 0

	gameState = 'start'

end

function love.update( dt )

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

	-- ball movement
	if gameState == 'play' then
		ball:update( dt )
	end

	paddle1:update( dt )
	paddle2:update( dt )

end

function love.keypressed( key )

	if key == 'escape' then
		love.event.quit()

	elseif key == 'enter' or key == 'return' then

		if gameState == 'start' then
			gameState = 'play'
		else
			gameState = 'start'

			-- call Ball reset method
			ball:reset()
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
	if gameState == 'start' then
		love.graphics.printf( 'Ready?', 0, 20, VIRTUAL_WIDTH, 'center' )
	elseif gameState == 'play' then
		love.graphics.printf( 'Pong!', 0, 20, VIRTUAL_WIDTH, 'center' )
	end

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
	paddle1:render()
	-- second paddle (right side)
	paddle2:render()
	-- ball
	ball:render()

	-- display FPS funtion call
	displayFPS()

	-- end rendering at virtual resolution
	push:apply( 'end' )

end

-- renders the current FPS
function displayFPS()

	love.graphics.setFont( smallFont )

	-- green color
	love.graphics.setColor( 0, 255 / 255, 0, 255 / 255 )
	love.graphics.print( 'FPS: ' .. tostring( love.timer.getFPS() ), 10, 10 )

end
