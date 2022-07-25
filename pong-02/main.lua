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

--[[
love.graphics.newFont( filename, size )
	Creates a new Font from a TrueType Font or BMFont file. Created fonts are
	not cached, in that calling this function with the same arguments will
	always create a new Font object.
	( This function can be slow if it is called repeatedly, such as from
	love.update or love.draw. If you need to use a specific resource often,
	create it once and store it somewhere it can be reused! )

love.graphics.setFont( font )
	Set an already-loaded Font as the current font or create and load a new one
	from the file and size.
]]

function love.load()

	love.graphics.setDefaultFilter( 'nearest', 'nearest' )

	-- should be after `setDefaultFilter` otherwise looks weird
	font = love.graphics.newFont( 'font.ttf', 8)
	love.graphics.setFont( font )

	-- replaces love.window.setMode() call
	push:setupScreen( VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})

end

function love.keypressed( key )

	if key == 'escape' then
		love.event.quit()
	end

end

--[[
love.graphics.clear()
	Clears the screen or active Canvas to the specified color.

love.graphics.rectangle( mode, x, y, width, height, rx, ry, segments )
	Draws a rectangle.
]]

function love.draw()

	-- begin rendering at virtual resolution
	push:apply( 'start' )

	-- color screen with the original game color instead of black
    love.graphics.clear( 40 / 255, 45 / 255, 52 / 255, 255 / 255 )

	-- now using virtual width and height for text placement
	love.graphics.printf(
		'Pong',
		0,
		20,
		VIRTUAL_WIDTH,
		'center'
	)

	-- first paddle (left side)
	love.graphics.rectangle( 'fill', 10, 30, 5, 20 )

	-- second paddle (right side)
	love.graphics.rectangle(
		'fill',
		VIRTUAL_WIDTH - 10,
		VIRTUAL_HEIGHT - 50,
		5,
		20
	)

	-- ball
	love.graphics.rectangle(
		'fill',
		VIRTUAL_WIDTH / 2 - 2,
		VIRTUAL_HEIGHT / 2 - 2,
		4,
		4
	)

	-- end rendering at virtual resolution
	push:apply( 'end' )

end
