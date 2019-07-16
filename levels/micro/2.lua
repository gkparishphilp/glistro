local physics = require( 'physics' )
local device = require( 'utilities.device' )

local mRand = math.random

local game = require( 'modules.game' )

local M = {}


M.name 		= 'Level 1'

M.music 	= "ambience1"

M.target_time = 30
M.target_collisions = 5

M.w 	= 800 -- device.actualContentWidth - 20 --560
M.h 	= 600 -- device.actualContentHeight - 40 -- 280

M.wallWidth = 20
M.wallFill = 'assets/textures/wood.jpg'

M.arena_bg 	= {
	fill 		= { type="image", filename='assets/textures/pale_water.jpg' },
	tx_size = 256,
	tx_scale = 1,
}

M.bg = {
	fill 		= { type="image", filename='assets/textures/sand.jpg' },
	tx_size = 256,
	tx_scale = 1,
}

M.heroX 	= M.w / 2
M.heroY 	= M.h / 2


M.spawns = {}
M.spawns['0'] = {
	--{ species = 'wall', type='inert', x=M.w/2, y=M.h*0.33, w=500, h=10, texture='assets/textures/brick.jpg' },
	--{ species = 'wall', type='inert', x=M.w/2, y=M.h*0.67, w=500, h=10, texture='assets/textures/brick.jpg' }

	{ count=3, species='block', type='inert', scaleFactor=0.33 },

	{ count=3, species='block', type='food', scaleFactor=0.25 },

	{ count=2, species='block', type='enemy', scaleFactor=0.25 },

	{ count=3, species='floater', type='food', scaleFactor=0.15 },

	{ count=3, species='floater', type='inert' },

	{ count=2, species='floater', type='enemy' },

	{ count=5, species='wanderer', type='inert', scaleFactor=0.35 },

	{ count=10, species='wanderer', type='food', scaleFactor=0.33 },

	{ species='follower', type='enemy', x=100, y=100, scaleFactor=0.5, speed=5 },
}

M.spawns['3'] = {
	{ count=10, species='wanderer', type='inert' },
	{ count=10, species='wanderer', type='food' },
}
-- M.spawns['20'] = {
-- 	{ count=10, species='wanderer', type='inert' },
-- 	{ count=10, species='wanderer', type='food' },
-- }

-- M.spawns['30'] = {
-- 	{ count=10, species='wanderer', type='inert' },
-- 	{ count=10, species='wanderer', type='food' },
-- }

return M
