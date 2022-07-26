-------------------------------------------------------------------------------
--
-- Paddle.lua
--
-- User: mlanca-c
-- URL: http://github.com/mlanca-c/CS50-pong
-- Version: 1.0
-------------------------------------------------------------------------------

Paddle = Class{}

-- initializes a Paddle object with the right attributes
function Paddle:init( x, y )

	-- initialize paddle coordinates
	self.x = x
	self.y = y
	self.width = PADDLE_WIDTH
	self.height = PADDLE_HEIGHT

	-- initialize paddle movement.
	-- The paddle only moves vertically and it's not moving at the moment.
	self.dy = 0

end

-- updates a Paddle object's attributes
function Paddle:update( dt )

	if self.dy < 0 then
		-- paddle is moving up
		self.y = math.max( 0, self.y + self.dy * dt )
	else
		-- paddle is moving down
		self.y = math.min( VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt )
	end
end

-- draws a Paddle object to the screen
function Paddle:render()
	love.graphics.rectangle( 'fill', self.x, self.y, self.width, self.height )
end
