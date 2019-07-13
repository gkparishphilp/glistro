
local physics = require( 'physics' )
local device = require( 'utilities.device' )
local gd = require( 'modules.gdata' )

local M = {}

M.defaults = {
	parent 	= display.newGroup(),
	x 		= device.centerX,
	y 		= device.centerY,
	width 	= 8,
	height 	= 8,
	type 	= 'inert',
	spawnDur = 1000,
	scaleFactor = 0.25
	
}

local function spawn( obj )

	local pd = require ( "assets.characters." .. 'micro' .. ".physics_defs" ).physicsData( obj.scaleFactor/2 )
	physics.addBody( obj, 'static', pd:get( obj.type .. '_' ..obj.species ) )
	
	if obj.type == 'food' then 
		gd.level_stats.food_count = gd.level_stats.food_count + 1 
		obj.density = 0.0001
		obj.bounce = 0.001
	else
		obj.density = 1
		obj.bounce = 1.01
	end
end

function M:new( args )
	
	-- fill in any missing args from module defaults
	if args == nil then args = M.defaults end
	for key, value in pairs( M.defaults ) do
		args[key] = args[key] or M.defaults[key]
	end

	local species = 'block'

	--local block = display.newRect( args.parent, args.x, args.y, args.width, args.height )

	local block = display.newImage( args.parent, args.parent.char_sheet, args.parent.char_sheet_info:getFrameIndex( args.type .. '_' .. species ) )
	block.x = args.x
	block.y = args.y
	block.scaleFactor = args.scaleFactor
	block:scale( 0.01, 0.01 )
	block.type = args.type
	block.species = species


	transition.to( block, { time=args.spawnDur, alpha=1, xScale=args.scaleFactor, yScale=args.scaleFactor, onComplete=function() spawn( block ); end } )
	

	function block:eachFrame( args )
		-- body
	end

	function block:cleanup()
		self:removeSelf()
	end

	return block
end


return M
