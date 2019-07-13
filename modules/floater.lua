
local physics = require( 'physics' )
local device = require( 'utilities.device' )
local gd = require( 'modules.gdata' )

local M = {}

M.defaults = {
	parent 		= display.newGroup(),
	x 			= device.centerX/2,
	y 			= device.centerY/2,
	size 		= 8,
	type 		= 'inert',
	spawnDur 	= 4000,
	scaleFactor = 0.33
}
 

local function spawn( obj )
	obj.alpha = 1
	local pd = require ( "assets.characters." .. 'micro' .. ".physics_defs" ).physicsData( obj.scaleFactor/2 )
	physics.addBody( obj, 'dynamic', pd:get( obj.type .. '_' ..obj.species ) )
	if obj.type == 'food' then 
		gd.level_stats.food_count = gd.level_stats.food_count + 1 
	end

	obj.status = 'live'

	obj:setLinearVelocity( math.random(-50, 50), math.random(-50, 50) )
	obj.linearDampening = 0
end


function M:new( args )
	
	-- fill in any missing args from module defaults
	if args == nil then args = M.defaults end
	for key, value in pairs( M.defaults ) do
		args[key] = args[key] or M.defaults[key]
	end

	local species = 'floater'


	local floater = display.newImage( args.parent, args.parent.char_sheet, args.parent.char_sheet_info:getFrameIndex( args.type .. '_' .. species ) )

	floater.type = args.type
	floater.species = species

	floater.scaleFactor = args.scaleFactor

	floater.species = species

	floater.x = args.x
	floater.y = args.y

	floater.status = 'spawning'

	floater:scale( 0.01, 0.01 )

	floater.alpha = 0

	transition.to( floater, { time=args.spawnDur, alpha=0.66, xScale=args.scaleFactor, yScale=args.scaleFactor, onComplete=function() spawn( floater ); end } )


	function floater:eachFrame( args )
	end

	function floater:cleanup()
		self:removeSelf()
	end

	return floater
end


return M
