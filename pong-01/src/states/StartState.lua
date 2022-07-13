--------------------------------------------------------------------------------
--
-- StartState.lua
--
-- User: mlanca-c
-- URL: http://github.com/mlanca-c/CS50-pong
-- Description: The StartState class is the beginning state of the game. It
-- 				makes the player choose between "Play", "HighScore", and
-- 				"Exit Game".
--------------------------------------------------------------------------------

StartState = Class{ __includes = BaseState }

function StartState:init()

	-- menu selection highlight flag
	self.highlight = 0

end

function StartState:update( dt )

	-- handling up and down keys for menu selection
	if love.keyboard.wasPressed( 'up' )
		or love.keyboard.wasPressed( 'w' ) then

		self.highlight = ( self.highlight - 1 ) % 2
		gSounds[ 'paddle_hit' ]:play()

	end
	if love.keyboard.wasPressed( 'down' )
		or love.keyboard.wasPressed( 's' ) then

		self.highlight = ( self.highlight + 1 ) % 2
		gSounds[ 'paddle_hit' ]:play()

	end

	-- handling enter press for menu selection
	if love.keyboard.wasPressed( 'enter' )
		or love.keyboard.wasPressed( 'return' ) then
		if self.highlight == 0 then

			-- selected "PLAY"
			gStateMachine:change( 'play' )
			gSounds[ 'score' ]:play()

		elseif self.highlight == 1 then
			-- selected "EXIT GAME"
			love.event.quit()
		end
	end

	-- -- quit game if escape is pressed
	-- if love.keyboard.wasPressed( 'escape' ) then
	-- 	love.event.quit()
	-- end

end

function StartState:render()

	-- Game title
	love.graphics.setFont( gFonts[ 'large' ] )
	love.graphics.printf(
		"Pong",
		--
		0,
		VIRTUAL_HEIGHT / 3,
		VIRTUAL_WIDTH,
		'center'
	)

	love.graphics.setFont( gFonts[ 'medium' ] )

	-- highligh 1
	if self.highlight == 0 then
		love.graphics.setColor( 121 / 255, 121 / 255, 121 / 255 )
	end
	love.graphics.printf(
		"PLAY",
		-- coordinates
		0,
		VIRTUAL_HEIGHT / 3 + 60,
		VIRTUAL_WIDTH,
		'center'
	)

	-- resetting color
    love.graphics.setColor( 1, 1, 1, 1 )

	-- highligh 2
	if self.highlight == 1 then
		love.graphics.setColor( 121 / 255, 121 / 255, 121 / 255 )
	end
	love.graphics.printf(
		"EXIT GAME",
		-- coordinates
		0,
		VIRTUAL_HEIGHT / 3 + 90,
		VIRTUAL_WIDTH,
		'center'
	)
	-- resetting color
    love.graphics.setColor( 1, 1, 1, 1 )

end
