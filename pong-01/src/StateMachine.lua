--------------------------------------------------------------------------------
--
-- StateMachine.lua
--
-- User: mlanca-c
-- URL: http://github.com/mlanca-c/CS50-pong
-- Description: state machine class that will handle the different game states
-- 				through the program's life
--------------------------------------------------------------------------------

StateMachine = Class{}

-- initializes a StateMachine object with the right attributes
function StateMachine:init( states )

	self.empty = {
		enter = function() end,
		update = function() end,
		render = function() end,
		exit = function() end
	}

	self.states = states or {}
	self.current = self.empty

end

function StateMachine:change( stateName, enterParams )

	-- making sure stateName exists inside self.states
	assert( self.states[ stateName ] )

	-- switching game current state for 'stateName'
	self.current:exit()
	self.current = self.states[ stateName ]()
	self.current:enter( enterParams )

end

function StateMachine:update( dt )
	self.current:update( dt )
end

function StateMachine:render()
	self.current:render()
end
