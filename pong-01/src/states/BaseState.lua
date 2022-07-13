--------------------------------------------------------------------------------
--
-- BaseState.lua
--
-- User: mlanca-c
-- URL: http://github.com/mlanca-c/CS50-pong
-- Description: skeleton of all state classes. This class will be inherited by
-- 				all game state classes.
--------------------------------------------------------------------------------

BaseState = Class{}

-- base methods for all the state classes
function BaseState:init() end
function BaseState:enter() end
function BaseState:update( dt ) end
function BaseState:render() end
function BaseState:exit() end
