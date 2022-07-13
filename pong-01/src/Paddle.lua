--------------------------------------------------------------------------------
--
-- Paddle.lua
--
-- User: mlanca-c
-- URL: http://github.com/mlanca-c/CS50-pong
-- Description: Represents a paddle that can move up and down. Used in the main
-- 				program to deflect the ball back toward the opponent.
--------------------------------------------------------------------------------

Paddle = Class{}

-- initializes a Paddle object with the right attributes
function Paddle:init( x, y )

	-- Paddle coordinates and speed (delta)
	self.x = x
	self.y = y
	self.dy = 0

	-- Paddle dimensions
	self.width = 5
	self.height = 20

end

-- updates a Paddle object's attributes
function Paddle:update( dt )
	-- handling paddle wall collision:
	-- if paddle is going down
	if self.dy >= 0 then
		self.y = math.min( VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt )
	end
	-- if paddle is going up
	if self.dy <= VIRTUAL_HEIGHT then
		self.y = math.max( 0, self.y + self.dy * dt )
	end
end

-- draws a Paddle object to the screen
function Paddle:render()

	love.graphics.rectangle(
		-- type
		'fill',
		-- coordinates
		self.x, self.y,
		self.width, self.height
	)

end
