
local physics = require( 'physics' )
local gd = require( 'modules.gdata' )
local device = require( 'utilities.device' )
local settings = require( 'modules.settings' )

local M = {}

M.defaults = {
	parent 	= display.newGroup(),
	x 		= device.centerX,
	y 		= device.centerY,
	scaleFactor 	= 1,
	spawnDur 		= 2000
	
}


local function spawn( obj )
	local pd = require ( "assets.characters." .. 'micro' .. ".physics_defs" ).physicsData( obj.scaleFactor/2 )
	physics.addBody( obj, 'dynamic', pd:get('hero') )
	obj.angularDamping = 100
	--obj.linearDamping = 0.1
end



function M:new( args )
	
	-- fill in any missing args from module defaults
	if args == nil then args = M.defaults end
	for key, value in pairs( M.defaults ) do
		args[key] = args[key] or M.defaults[key]
	end

	--local hero = display.newImageRect( args.parent, 'assets/characters/spacecow/hero.png', 128, 128 )
	local hero = display.newImage( args.parent, args.parent.char_sheet, args.parent.char_sheet_info:getFrameIndex( 'hero' ) )
	hero.x = args.x
	hero.y = args.y
	hero.name = 'hero'
	hero.scaleFactor = args.scaleFactor

	hero:scale( 0.01, 0.01 )


	transition.to( hero, { time=args.spawnDur, alpha=1, xScale=args.scaleFactor, yScale=args.scaleFactor, onComplete=function() spawn( hero ); end } )



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
