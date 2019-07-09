
-- This is the global data for the app 
-- It includes any data that needs to be shared between modules


local debugger = require( 'utilities.debug' )


local sysInfo = system.getInfo

local M = {}

M.cur_mode = 'playnow'
M.cur_level = 1
M.game_state = 'paused' -- active, complete, dead


-- the stats for a given level
M.level_stats = {
	score = 0,
	food_count = 0,
	target_collisions = 0,
	eaten_count = 0,
	collision_count = 0,
	elapsed_time 	= 0,
	target_time 	= 0,
	collision_bonus = 0,
	time_bonus 		= 0
}

-- the stats for a session.... one trip through a level sequence
M.session_stats = {
	score = 0,
	eaten_count = 0,
	collision_count = 0,
	elapsed_time 	= 0
}


-- the entire time the app's been open
-- maybe even save these to file for lifetime or user stats?
M.total_stats = {
	score = 0,
	eaten_count = 0,
	collision_count = 0,
	elapsed_time 	= 0
}





function M.reset_level_stats()
	M.level_stats = {
		score = 0,
		food_count = 0,
		target_collisions = 0,
		eaten_count = 0,
		collision_count = 0,
		elapsed_time 	= 0,
		target_time 	= 0,
		collision_bonus = 0,
		time_bonus = 0
	}
end

function M.reset_session_stats()
	M.session_stats = {
		score = 0,
		eaten_count = 0,
		collision_count = 0,
		elapsed_time 	= 0,
	}
end

function M.update_session_stats()
	M.session_stats.eaten_count = M.session_stats.eaten_count + M.level_stats.eaten_count
	M.session_stats.collision_count = M.session_stats.collision_count + M.level_stats.collision_count
	M.session_stats.elapsed_time = M.session_stats.elapsed_time + M.level_stats.elapsed_time
end


function M.update_total_stats()
	M.total_stats.score = M.total_stats.score + M.level_stats.score
	M.total_stats.eaten_count = M.total_stats.eaten_count + M.level_stats.eaten_count
	M.total_stats.collision_count = M.total_stats.collision_count + M.level_stats.collision_count
	M.total_stats.elapsed_time = M.total_stats.elapsed_time + M.level_stats.elapsed_time
end



return M


