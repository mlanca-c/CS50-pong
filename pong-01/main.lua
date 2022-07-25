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
love.graphics.setDefaultFilter( min, mag )
	Sets the default scaling filters used with Images, Canvases, and Fonts.
	`min` - filter mode used when scaling the image down.
	`mag` - filter mode used when scaling the image up.
]]

function love.load()

	love.graphics.setDefaultFilter( 'nearest', 'nearest' )

	-- replaces love.window.setMode() call
	push:setupScreen( VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})

end

--[[
love.keypressed( key, [scancode], [isrepeat] )
	Callback function triggered when a key is pressed.

love.event.quit( exitstatus )
	Adds the quit event to the queue. Equivalent to
	`love.event.push( "quit", exitstatus )``
]]

function love.keypressed( key )

	if key == 'escape' then
		love.event.quit()
	end

end

function love.draw()

	-- begin rendering at virtual resolution
	push:apply( 'start' )

	-- now using virtual width and height for text placement
	love.graphics.printf(
		'Hello Pong!',
		0,
		VIRTUAL_HEIGHT / 2,
		VIRTUAL_WIDTH,
		'center'
	)

	-- end rendering at virtual resolution
	push:apply( 'end' )

end
