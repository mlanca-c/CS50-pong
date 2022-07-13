--------------------------------------------------------------------------------
--
-- main.lua
--
-- User: mlanca-c
-- URL: http://github.com/mlanca-c/CS50-pong
-- Description: This is the main file of the game. The game is a remake of the
-- 				famous pong game. "Pong" is  simple 2 player game in which one
-- 				player has a paddle on the left side of the screen, the other
-- 				player has a paddle on the right side of the screen, and the
-- 				first player to score 10 times on their opponent wins. A player
-- 				scores by getting the ball past the opponent’s paddle and into
-- 				their “goal” (i.e., the edge of the screen).
--------------------------------------------------------------------------------

-- require file with all other dependent files
require 'src/Dependencies'

-- love.load() it's used to initialize game state at the very beginning.
function love.load()

	love.graphics.setDefaultFilter( 'nearest', 'nearest' )

	-- Setting up window title
	love.window.setTitle( 'Pong' )

	-- Setting up game's fonts inside table
	gFonts = {
		[ 'small' ] = love.graphics.newFont( 'fonts/font.ttf', 8 ),
		[ 'medium' ] = love.graphics.newFont( 'fonts/font.ttf', 16 ),
		[ 'large' ] = love.graphics.newFont( 'fonts/font.ttf', 32 )
	}
	love.graphics.setFont( gFonts[ 'small' ] )

	-- Setting up game window
	push:setupScreen(
		VIRTUAL_WIDTH,
		VIRTUAL_HEIGHT,
		WINDOW_WIDTH,
		WINDOW_HEIGHT,
		{ fullscreen = false, resizable = true, vsync = true }
	)

	-- Setting up game's sounds inside table
	gSounds = {
		[ 'paddle_hit' ] = love.audio.newSource( 'sounds/paddle_hit.wav', 'static' ),
		[ 'score' ] = love.audio.newSource( 'sounds/score.wav', 'static' ),
		[ 'wall_hit' ] = love.audio.newSource( 'sounds/wall_hit.wav', 'static' )
	}

	-- Setting up state machine inside table
	gStateMachine = StateMachine{
		[ 'start' ] = function() return StartState() end,
		[ 'play' ] = function() return PlayState() end
	}
	gStateMachine:change( 'start' )

	-- Setting up keysPressed table
	love.keyboard.keysPressed = {}

end

-- love.update(dt) updates the state of the game every frame.
function love.update( dt )

	gStateMachine:update( dt )

	-- Resetting keysPressed table
	love.keyboard.keysPressed = {}

end

-- love.draw() is called right after love.update(dt) and draws an image to the
-- window
function love.draw()

	push:start()
	-- drawing starts here

	gStateMachine:render()

	displayFPS()

	-- drawing ends here
	push:finish()

end

function love.keypressed( key )
	love.keyboard.keysPressed[ key ] = true
end

function love.keyboard.wasPressed( key )
	return love.keyboard.keysPressed[ key ]
end

function love.resize( w, h )
	push:resize( w, h )
end

function displayFPS()

	-- Setting up font
	love.graphics.setFont( gFonts[ 'small' ] )
	love.graphics.setColor( 0 / 255, 255 / 255, 0 / 255 )
	love.graphics.print(
		"FPS: " .. tostring( love.timer.getFPS() ),
		10, 10
	)
	-- resetting color to white
	love.graphics.setColor( 1 / 255, 1 / 255, 1 / 255 )

end
