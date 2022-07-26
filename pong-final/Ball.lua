-------------------------------------------------------------------------------
--
-- Ball.lua
--
-- User: mlanca-c
-- URL: http://github.com/mlanca-c/CS50-pong
-- Version: 1.0
-------------------------------------------------------------------------------

Ball = Class{}

-- initializes a Ball object with the right attributes
function Ball:init( x, y )

	-- initialize paddle coordinates
	self.x = x
	self.y = y
	self.width = BALL_WIDTH
	self.height = BALL_HEIGHT

	-- initialize paddle movement.
	self.dx = math.random(2) == 1 and -100 or 100
	self.dy = math.random(2) == 1 and math.random( -80, -100 ) or math.random( 80, 100 )

end

-- updates a Ball object's attributes
function Ball:update( dt )

	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

end

-- draws a Ball object to the screen
function Ball:render()
	love.graphics.rectangle( 'fill', self.x, self.y, self.width, self.height )
end

-- resents all class attributes to their initial value
function Ball:reset()

	-- reseting values to their initial value
	self.x = VIRTUAL_WIDTH / 2 - 2
	self.y = VIRTUAL_HEIGHT / 2 - 2
	self.dx = math.random(2) == 1 and -100 or 100
	self.dy = math.random(2) == 1 and math.random( -80, -100 ) or math.random( 80, 100 )

end

-- returns true if ball is colliding with paddle
function Ball:collides( paddle )

	if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
		return false
	end
	if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
		return false
	end

	return true

end
