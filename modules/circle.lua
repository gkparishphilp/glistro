
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
	
}
 

local function spawn( obj )
	physics.addBody( obj, 'dynamic', { radius=obj.width * 0.5, bounce=1, friction=0, density=0.5 } )
	if obj.type == 'food' then gd.level_stats.food_count = gd.level_stats.food_count + 1 end
	--obj:applyLinearImpulse( math.random()/1000*obj.width, math.random()/1000*obj.width, obj.x, obj.y )
	obj:setLinearVelocity( math.random(-obj.width*5, obj.width*5), math.random(-obj.width*5, obj.width*5) )
	obj.linearDampening = 0
end


function M:new( args )
	
	-- fill in any missing args from module defaults
	if args == nil then args = M.defaults end
	for key, value in pairs( M.defaults ) do
		args[key] = args[key] or M.defaults[key]
	end

	local circle = {}

	circle = display.newCircle( args.parent, args.x, args.y, args.size )
	circle:scale( 0.1, 0.1 )

	circle.type = args.type

	local mask = display.newCircle( args.parent, args.x, args.y, args.size )
	mask.fill = { 1, 1, 1, 0.9 }
	mask:scale( 0.1, 0.1 )

	if args.type == 'inert' then
		circle.fill = { 0, 0, 1, 1 }
		circle.stroke = { 0.5, 0.5, 1, 1 }
	elseif args.type == 'food' then
		circle.fill = { 0, 1, 0, 1 }
		circle.stroke = { 0.5, 1, 0.5, 1 }
	elseif args.type == 'cue' then
		circle.fill = { 0.0, 0.1, 0.1, 1 }
		circle.stroke = { 0.33, 0.33, 0.33, 1 }
	elseif args.type == 'enemy' then
		circle.fill = { 1, 0, 0, 1 }
		circle.stroke = { 1, 0.5, 0.5, 1 }
	end

	circle.strokeWidth = 1

	circle.alpha = 0

	circle.type = args.type

	transition.to( mask, { time=args.spawnDur, xScale=1, yScale=1, onComplete=function() mask:removeSelf(); mask=nil; end } )
	transition.to( circle, { time=args.spawnDur, alpha=1, xScale=1, yScale=1, onComplete=function() spawn( circle ); end } )


	function circle:eachFrame( args )
	end

	function circle:cleanup()
		self:removeSelf()
	end

	return circle
end


return M
