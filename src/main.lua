-------------------------------------------------------------------------------
--
-- main.lua
--
-- User: mlanca-c
-- URL: http://github.com/mlanca-c/CS50-pong
-- Version: 1.0
-------------------------------------------------------------------------------

-- Base Functions --

-- love.load() used for initializing game state at the very beginning of the
--             program execution - Whatever code we put here will be executed
--             at the very beginning of the program.

-- love.update(dt) this function is called by LÖVE at each frame of program
--                 execution. dt (DeltaTime) will be the elapsed time in
--                 seconds since the last frame, and we can use this to scale
--                 any changes in our game for even behaviour across frames.

-- love.draw() This function is also called at each frame by LÖVE. It is called
--             after the update step completes so that we can draw things to the
--             screen once they've changed.

-- LÖVE2D expects all these functions to be implemented in main.lua and calls
-- them internally


-- love.graphics.printf(text, x, y, [width], [align]) versatile print function
--                                                    that can align text left,
--                                                    right or center of the
--                                                    screen.

-- love.window.setMode(width, height, params) Used to initialize the window's
--                                            dimensions and to set parameters
--                                            like vsync (vertical sync),
--                                            whether we're fullscreen or not,
--                                            and whether the window is
--                                            resizable after startup. We won't
--                                            be using this functions past this
--                                            example in favor of the `push`
--                                            virtual resolution library, which
--                                            has its own method like this, but
--                                            it is useful to know if
--                                            encountered in other code.

-- Code --

-- initialize our game by specifying in the love.load() function that our
-- 1280x720 window shouldn't be fullscreen or resizable, but it should be
-- synced to our monitor's own refresh rate.

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()
	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})
end

-- overwrite the love.draw() function so that we can specify the text we'd like to
-- render to the screen, in this case "Hello Pong!", along with the coordinates
-- where it shold be drawn.

function love.draw()
	love.graphics.printf(
		'Hello Pong!',
		0,
		WINDOW_HEIGHT / 2 - 6,
		WINDOW_WIDTH,
		'center'
	)
end
