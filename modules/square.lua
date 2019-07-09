
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
	
}

local function spawn( obj )
	
	if obj.type == 'food' then 
		physics.addBody( obj, 'kinematic', { bounce=0, friction=0, density=0.5 } )
		gd.level_stats.food_count = gd.level_stats.food_count + 1 
		obj.density = 0.01
		obj.bounce = 0.5
	else
		physics.addBody( obj, 'static', { bounce=1.05, friction=0, density=0.5 } )
	end
	--obj:applyLinearImpulse( math.random()/1000*obj.width, math.random()/1000*obj.width, obj.x, obj.y )
end

function M:new( args )
	
	-- fill in any missing args from module defaults
	if args == nil then args = M.defaults end
	for key, value in pairs( M.defaults ) do
		args[key] = args[key] or M.defaults[key]
	end

	local square = display.newRect( args.parent, args.x, args.y, args.width, args.height )
	square:scale( 0.1, 0.1 )
	square.type = args.type

	local mask = display.newRect( args.parent, args.x, args.y, args.width, args.height )
	mask.fill = { 1, 1, 1, 0.9 }
	mask:scale( 0.1, 0.1 )
	
	if args.type == 'inert' then
		square.fill = { 0, 0, 1, 1 }
		square.stroke = { 0.5, 0.5, 1, 1 }
	elseif args.type == 'food' then
		square.fill = { 0, 1, 0, 1 }
		square.stroke = { 0.5, 1, 0.5, 1 }
	elseif args.type == 'cue' then
		square.fill = { 0.75, 0.75, 0.75, 1 }
		square.stroke = { 0.33, 0.33, 0.33, 1 }
	elseif args.type == 'enemy' then
		square.fill = { 1, 0, 0, 1 }
		square.stroke = { 1, 0.5, 0.5, 1 }
	end

	square.strokeWidth = 1


	if args.texture then
		display.setDefault( "textureWrapX", "repeat" )
		display.setDefault( "textureWrapY", "repeat" )
		square.fill = { type="image", filename=args.texture }
	end

	transition.to( mask, { time=args.spawnDur, xScale=1, yScale=1, onComplete=function() mask:removeSelf(); mask=nil; end } )
	transition.to( square, { time=args.spawnDur, alpha=1, xScale=1, yScale=1, onComplete=function() spawn( square ); end } )
	

	function square:eachFrame( args )
		-- body
	end

	function square:cleanup()
		self:removeSelf()
	end

	return square
end


return M
