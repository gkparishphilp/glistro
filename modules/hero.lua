
local physics = require( 'physics' )
local gd = require( 'modules.gdata' )
local device = require( 'utilities.device' )
local settings = require( 'modules.settings' )

local M = {}

M.defaults = {
	parent 	= display.newGroup(),
	x 		= device.centerX,
	y 		= device.centerY,
	size 	= 24,
	
}

function M:new( args )
	
	-- fill in any missing args from module defaults
	if args == nil then args = M.defaults end
	for key, value in pairs( M.defaults ) do
		args[key] = args[key] or M.defaults[key]
	end

	local hero = display.newCircle( args.parent, args.x, args.y, args.size )
	
	hero.fill = { 1, 1, 0, 1 }

	hero.name = 'hero'

	display.setDefault( "textureWrapX", "repeat" )
	display.setDefault( "textureWrapY", "repeat" )
	hero.fill = { type="image", filename='assets/characters/spacecow/hero.png' }

	physics.addBody( hero, 'dynamic', { radius=args.size*0.66, density=10, bounce=0.001 } )


	function hero:cleanup()
		self:removeSelf()
	end


	function hero:move( event )
		if event.phase == 'moved' then
			local dx, dy = self:getLinearVelocity()
			local angle = math.atan2( dy, dx )
			angle = ( angle * ( 180 / math.pi ) ) + 90
			self.rotation = angle
			local xForce = ( event.x - event.xStart ) / ( 1/settings.sensitivity*1000 )
			local yForce = ( event.y - event.yStart ) / ( 1/settings.sensitivity*1000 )
			self:applyLinearImpulse( xForce, yForce, self.x, self.y )
		end
	end

	return hero
end


return M
