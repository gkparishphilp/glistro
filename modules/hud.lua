
local Clock = require( 'modules.clock' )
local gd = require( 'modules.gdata' )
local device = require( 'utilities.device' )

local M = {}

M.defaults = {
	parent	= display.newGroup(),
	fontSize 	= 10,
	height		= 36,
	
}

function M:new( args )
	
	-- fill in any missing args from module defaults
	if args == nil then args = M.defaults end
	for key, value in pairs( M.defaults ) do
		args[key] = args[key] or M.defaults[key]
	end

	local hud = display.newGroup()
	args.parent:insert( hud )

	hud.h = args.height

	hud.bg = display.newRect( hud, device.screenLeft, device.screenTop, device.screenWidth, hud.h )
	hud.bg.anchorX, hud.bg.anchorY = 0, 0
	hud.bg.fill = { 0, 0, 0, 0.75 }


	hud.level_label = display.newText({
		parent 		= hud,
		text 		= 'Level:',
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= args.fontSize,
		x 			= device.safeOriginX + 10,
		y 			= args.height / 2,
	})
	hud.level_label.anchorX = 0

	hud.level_value = display.newText({
		parent 		= hud,
		text 		= gd.cur_level,
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= args.fontSize,
		x 			= hud.level_label.x + hud.level_label.width,
		y 			= args.height / 2,
	})
	hud.level_value.anchorX = 0


	hud.score_label = display.newText({
		parent 		= hud,
		text 		= 'Score:',
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= args.fontSize,
		x 			= hud.level_value.x + hud.level_value.width + 20,
		y 			= args.height / 2,
		--width 		= 30
	})
	hud.score_label.anchorX = 0
	
	hud.score_value = display.newText({
		parent 		= hud,
		text 		= gd.session_stats.score,
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= args.fontSize,
		x 			= hud.score_label.x + hud.score_label.width,
		y 			= args.height / 2,
	})
	hud.score_value.anchorX = 0
	Runtime:addEventListener( 'enterFrame', function() hud.score_value.text = gd.session_stats.score; end )



	



	hud.collision_label = display.newText({
		parent 		= hud,
		text 		= 'Hits:',
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= args.fontSize,
		x 			= hud.score_value.x + hud.score_value.width + 20,
		y 			= args.height / 2,
	})
	hud.collision_label.anchorX = 0

	hud.collision_value = display.newText({
		parent 		= hud,
		text 		= gd.level_stats.collision_count .. '/' .. gd.level_stats.target_collisions,
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= args.fontSize,
		x 			= hud.collision_label.x + hud.collision_label.width,
		y 			= args.height / 2,
	})
	Runtime:addEventListener( 'enterFrame', function() hud.collision_value.text = gd.level_stats.collision_count .. '/' .. gd.level_stats.target_collisions; end )
	hud.collision_value.anchorX = 0

	hud.food_label = display.newText({
		parent 		= hud,
		text 		= 'Food:',
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= args.fontSize,
		x 			= hud.collision_value.x + hud.collision_value.width + 20,
		y 			= args.height / 2,
	})
	hud.food_label.anchorX = 0

	hud.food_value = display.newText({
		parent 		= hud,
		text 		= "0/0",
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= args.fontSize,
		x 			= hud.food_label.x + hud.food_label.width,
		y 			= args.height / 2,
	})
	hud.food_value.anchorX = 0
	Runtime:addEventListener( 'enterFrame', function() hud.food_value.text = gd.level_stats.eaten_count .. '/' .. gd.level_stats.food_count; end )


	hud.clock  = Clock:new({
		group 	= hud,
		fontSize = 8,
		fontFill = { 1, 1, 1 },
		showHunds = true,
		font = 'assets/fonts/press_play.ttf',
		})
	hud.clock.x = hud.food_value.x + hud.clock.contentWidth + 20
	hud.clock.y = args.height / 2
	hud.clock:reset()

	-- hud.pause_btn = display.newText({
	-- 	parent 	= hud,
	-- 	text 	= 'Pause',
	-- 	font 		= 'assets/fonts/press_play.ttf',
	-- 	fontSize 	= args.fontSize,
	-- 	x 			= device.screenWidth - 10,
	-- 	y 			= args.height / 2,
	-- })
	-- hud.pause_btn.anchorX = 1

	

	hud.pause_lbl = display.newText({
		parent 		= hud,
		text 		= "Pause",
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= 10,
		x 			= device.screenWidth - 20,
		y 			= args.height / 2,
	})
	hud.pause_lbl.anchorX = 1

	hud.pause_btn = display.newRoundedRect( hud, device.screenWidth - 10, args.height / 2, hud.pause_lbl.contentWidth+20, 20, 4 )
	hud.pause_btn.anchorX = 1
	hud.pause_btn.fill = { 0,0,0,1 }
	hud.pause_btn:setStrokeColor( 1, 1, 1, 0.5 )
	hud.pause_btn.strokeWidth = 1

	hud.pause_lbl:toFront()

	hud.hr = display.newRect( hud, device.centerX, hud.h, device.screenWidth, 1 )
	hud.hr.fill = { 1, 1, 1, 0.25 }


	function hud:cleanup()
		self.clock:cleanup()
		self:removeSelf()
	end

	return hud
end


return M

