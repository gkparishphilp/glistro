local physics = require( 'physics' )
local device = require( 'utilities.device' )

local mRand = math.random

local game = require( 'modules.game' )

local M = {}


M.name 		= 'Level 1'

M.music 	= "ambience1"

M.target_time = 30
M.target_collisions = 5

M.w 	= device.actualContentWidth * 1.25 --560
M.h 	= device.actualContentHeight * 1.25 -- 280

M.wallWidth = 10
M.wallFill = { type="image", filename='assets/textures/wood.jpg' }

M.arena_bg 	= {
	fill 		= { type="image", filename='assets/textures/space1.jpg' },
	tx_size = 512,
	tx_scale = 1,
}

M.bg = {
	fill 		= { type="image", filename='assets/textures/geo1.jpg' },
	tx_size = 128,
	tx_scale = 1,
}

M.heroX 	= M.w / 2
M.heroY 	= M.h / 2


M.spawns = {}
M.spawns['0'] = {
	{ count=5, shape='square', type='inert' },
	{ count=10, shape='square', type='food' },

	{ count=5, shape='circle', type='food' },
	{ count=5, shape='circle', type='inert' },
	--{ shape='square', type='enemy', x=device.centerX, y=device.centerY-100, w=300, h=10 },
	--{ shape='square', type='enemy', x=device.centerX, y=device.centerY+100, w=300, h=10 },
}

M.spawns['10'] = {
	{ count=5, shape='square', type='inert' },
	{ count=5, shape='circle', type='inert' },
}

M.spawns['20'] = {
	{ count=10, shape='square', type='inert' },
	{ count=5, shape='circle', type='inert' },
}

M.spawns['30'] = {
	{ count=10, shape='square', type='inert' },
	{ count=10, shape='circle', type='inert' },
}


return M