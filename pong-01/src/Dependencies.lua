--------------------------------------------------------------------------------
--
-- Dependencies.lua
--
-- User: mlanca-c
-- URL: http://github.com/mlanca-c/CS50-pong
-- Description: this file contains all dependencie files that main.lua needs
--------------------------------------------------------------------------------

-- library used for a more retro looking game.
-- source: https://github.com/Ulydev/push
push = require 'lib/push'

-- library used for a more OOP aproach
-- source: https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'

-- contains most of the constant and global variables of the program
require 'src/constants'

-- state machine class
require 'src/StateMachine'

-- all state files
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'
