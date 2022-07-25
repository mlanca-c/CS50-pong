--------------------------------------------------------------------------------
--
-- main.lua
--
-- User: mlanca-c
-- URL: http://github.com/mlanca-c/CS50-pong
-- Version: 1.0
--------------------------------------------------------------------------------

-- Base Functions --

-- love.graphics.setDefaultFilter(min, mag) sets the texture scaling filter when
--                                          minimizing and magnifying textures
--                                          and fonts. LÖVE’s default is
--                                          bilinear, which causes bluriness,
--                                          but for our use cases we will
--                                          typically want nearest-neighnour
--                                          filtering (nearest), whcih results
--                                          in perfect pixel upscaling and
--                                          downscaling, simulating a retro feel

-- love.keypressed(key) this is LÖVE2D callback function that executes whenever
--                      we press a key, assuming we've implemented this is
--                      `main.lua`, in the same vein as love.load(),
--                      love.update(dt), and love.draw(). It'll allow us to
--                      receive input from the keyboard for our game.

-- love.event.quit() single function that termia=nates the application

-- Code --

-- We've begun using the `push` library. You can import other files in your
-- main.lua file with the `require` keyword given that they are in the same
-- directory

push = require 'push'

WINDOW_WIDTH = 1820
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- using the push library to treat our game as if it were on a 432x243 window,
-- while actually rendering it at our desired 1280x720 window.
function love.load()

	love.graphics.setDefaultFilter('nearest', 'nearest')

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})

end

-- quit the game via user input

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

-- small tweak to our love.draw() function so as to integrate the push library into the code.

function love.draw()
	push:apply('start')
	love.graphics.printf(
		'Hello Pong!',
		0,
		VIRTUAL_HEIGHT / 2,
		VIRTUAL_WIDTH,
		'center'
	)
	push:apply('end')
end
