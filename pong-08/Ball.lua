-------------------------------------------------------------------------------
--
-- Ball.lua
--
-- User: mlanca-c
-- URL: http://github.com/mlanca-c/CS50-pong
-- Version: 1.0
-------------------------------------------------------------------------------

Ball = Class{}

--[[
Places the ball in the x and y coordinates, with an initial random velocity
on both axes.
]]
function Ball:init( x, y, width, height )

	self.x = x
	self.y = y
	self.width = width
	self.height = height

	self.dy = math.random( 2 ) == 1 and -100 or 100
    self.dx = math.random( -50, 50 )

end

function Ball:collides( paddle )

	if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
		return false
	end

	if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

	return true

end
--[[
Places the ball in the middle of the screen, with an initial random velocity
on both axes.
]]
function Ball:reset()

	self.x = VIRTUAL_WIDTH / 2 - 2
	self.y = VIRTUAL_HEIGHT / 2 - 2

	self.dx = math.random( 2 ) == 1 and -100 or 100
    self.dx = math.random( -50, 50 )

end

--[[
Applies velocity to position, scaled by deltaTime.
]]
function Ball:update( dt )

	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

end

function Ball:render()

	love.graphics.rectangle(
		'fill',
		self.x,
		self.y,
		self.width,
		self.height
	)

end
