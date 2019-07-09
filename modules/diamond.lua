
local physics = require( 'physics' )
local device = require( 'utilities.device' )

local debugger = require( 'utilities.debug' )

local M = {}

M.defaults = {
	x 		= device.centerX/2,
	y 		= device.centerY/2,
	size 	= 8,
	type 	= 'powerup',
	parent 	= display.newGroup(),
	image 	= 'assets/images/characters/bytes/diamond.png',
	frequency = 2, -- one out of this chance per frame that it will move
	speed 	  = 10000 -- angle of movement gets divided by this, so the smaller it is, the faster the object moves
}

function M:new( args )
	
	-- fill in any missing args from module defaults
	if args == nil then args = M.defaults end
	for key, value in pairs( M.defaults ) do
		args[key] = args[key] or M.defaults[key]
	end

	--local verts = {   2.5, 2.5  ,  -2, 11  ,  -6.5, 2.5  ,  -2, -6  }
	local verts = {  2, 30  ,  -8, 50  ,  -18, 30  ,  -8, 11  }


	local diamond = display.newPolygon( args.parent, args.x, args.y, verts )
	diamond:scale( 0.5, 0.5 )
	
	diamond.type = args.type
	diamond.frequency = args.frequency
	
	if args.type == 'inert' then
		diamond.fill = { 0, 0, 1, 1 }
		diamond.stroke = { 0.5, 0.5, 1, 1 }
	elseif args.type == 'food' then
		diamond.fill = { 0, 1, 0, 1 }
		diamond.stroke = { 0.5, 1, 0.5, 1 }
	elseif args.type == 'cue' then
		diamond.fill = { 0.75, 0.75, 0.75, 1 }
		diamond.stroke = { 0.33, 0.33, 0.33, 1 }
	elseif args.type == 'enemy' then
		diamond.fill = { 1, 0, 0, 1 }
		diamond.stroke = { 1, 0.5, 0.5, 1 }
	end

	diamond.strokeWidth = 1

	local pd = require ( 'assets.images.characters.bytes.diamond' ).physicsData( 0.33 )
	physics.addBody( diamond, 'dynamic', pd:get('diamond') )


	function diamond:eachFrame( args )

		if math.random( self.frequency ) <= 1 then
			self:setFillColor( math.random(0.5, 1), math.random(0.5, 1), math.random(0.5, 1), 1 )
			self:setStrokeColor( math.random(), math.random(), math.random(), 1 )
		end
	end

	function diamond:cleanup()
		self:removeSelf()
	end

	return diamond
end


return M
