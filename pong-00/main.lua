-------------------------------------------------------------------------------
--
-- main.lua
--
-- User: mlanca-c
-- URL: http://github.com/mlanca-c/CS50-pong
-- Version: 1.0
-------------------------------------------------------------------------------

--[[
love.load( arg, unfilteredArg )
	is called exactly once at the beginning of the game. `arg` command line
	arguents given to the game. 'unfilteredArg' unfiltered command line arguents
	given to the executable. Used for initializing game state at the very
	beginning of the program execution

love.window.setMode( width, height, params )
	love.window provides an interface for modifying and retrieving information
	about the program's window. setMode sets the display mode and properties of
	the window.
]]

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()

	love.window.setMode( WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})

end

--[[
love.draw()
	Callback function used to draw on the screen every frame.

love.graphics.printf( text, x, y, [width], [align] )
	Draws formatted text, with word wrap and alignment.
]]

function love.draw()

	love.graphics.printf(
		'Hello Pong!',
		0,
		WINDOW_HEIGHT / 2,
		WINDOW_WIDTH,
		'center'
	)

end
