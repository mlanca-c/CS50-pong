--------------------------------------------------------------------------------
--
-- PlayState.lua
--
-- User: mlanca-c
-- URL: http://github.com/mlanca-c/CS50-pong
-- Description: The PlayState class is the bulk of the game, where the players
-- 				actually control the paddles. When a player presses the space
-- 				bar, the game is paused. When the player presses the esc key,
-- 				the game switches state to the StartState.
--------------------------------------------------------------------------------

PlayState = Class{ __includes = BaseState }

function PlayState:init()

	-- initializing paddle1 - on the left
	self.paddle1 = Paddle( 10, 30 )
	-- initializing paddle2 - on the right
	self.paddle2 = Paddle( VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30 )

	-- paused flag for the game
	self.paused = false

end

function PlayState:update( dt )

	-- toggling `paused` when space is pressed
	if love.keyboard.wasPressed( 'space' ) then
		self.paused = self.paused == false and true or false
	end

	-- haddling the Paddles' movements
	if self.paused == false then

		-- paddle1 movement
		if love.keyboard.isDown( 's' ) then
			self.paddle1.dy = PADDLE_SPEED
		elseif love.keyboard.isDown( 'w' ) then
			self.paddle1.dy = -PADDLE_SPEED
		else
			self.paddle1.dy = 0
		end

		-- paddle2 movement
		if love.keyboard.isDown( 'down' ) then
			self.paddle2.dy = PADDLE_SPEED
		elseif love.keyboard.isDown( 'up' ) then
			self.paddle2.dy = -PADDLE_SPEED
		else
			self.paddle2.dy = 0
		end

		-- updating paddles
		self.paddle1:update( dt )
		self.paddle2:update( dt )

	end

	-- changing to StartState if escape key is pressed
	if love.keyboard.wasPressed( 'escape' ) then
		gStateMachine:change( 'start' )
	end
end

function PlayState:render()

	-- drawing middle line
	love.graphics.rectangle(
		-- type
		'fill',
		-- coordinates
		VIRTUAL_WIDTH / 2, 0,
		5, VIRTUAL_HEIGHT
	)

	-- render paddles
	self.paddle1:render()
	self.paddle2:render()

	if self.paused then

		love.graphics.setFont( gFonts[ 'large' ] )
		love.graphics.printf(
			"PAUSE",
			-- coordinates
			0,
			VIRTUAL_HEIGHT / 3,
			VIRTUAL_WIDTH,
			'center'
		)

	end
end
