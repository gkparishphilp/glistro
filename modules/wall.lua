
local physics = require( 'physics' )
local device = require( 'utilities.device' )
local gd = require( 'modules.gdata' )

local M = {}

M.defaults = {
	x 		= device.centerX,
	y 		= device.centerY,
	w 		= 8,
	h 		= 8,
	type 	= 'inert',
	spawnTime = 1000,
	parent 	= display.newGroup(),
}

local function spawn( obj )
	physics.addBody( obj, 'static', { bounce=1.01, friction=0, density=2 } )
end

function M:new( args )
	
	-- fill in any missing args from module defaults
	if args == nil then args = M.defaults end
	for key, value in pairs( M.defaults ) do
		args[key] = args[key] or M.defaults[key]
	end

	local wall = display.newRect( args.parent, args.x, args.y, args.w, args.h )
	wall:scale( 0.1, 0.1 )
	wall.type = args.type
	wall.species = 'wall'

	if args.type == 'inert' then
		wall.fill = { 0, 0, 1, 1 }
		wall.stroke = { 0.5, 0.5, 1, 1 }
	elseif args.type == 'food' then
		wall.fill = { 0, 1, 0, 1 }
		wall.stroke = { 0.5, 1, 0.5, 1 }
	elseif args.type == 'cue' then
		wall.fill = { 0.75, 0.75, 0.75, 1 }
		wall.stroke = { 0.33, 0.33, 0.33, 1 }
	elseif args.type == 'enemy' then
		wall.fill = { 1, 0, 0, 1 }
		wall.stroke = { 1, 0.5, 0.5, 1 }
	end

	if args.texture then
		display.setDefault( "textureWrapX", "repeat" )
		display.setDefault( "textureWrapY", "repeat" )
		wall.fill = { type="image", filename=args.texture }
		wall.fill.scaleX = wall.contentWidth / 256
		wall.fill.scaleY = wall.contentHeight / 256
	end

	transition.to( wall, { time=args.spawnTime, alpha=1, xScale=1, yScale=1, onComplete=function() spawn( wall ); end } )
	

	function wall:eachFrame( args )
		-- body
	end

	function wall:cleanup()
		self:removeSelf()
	end

	return wall
end


return M
