
local physics = require( 'physics' )
local device = require( 'utilities.device' )
local gd = require( 'modules.gdata' )

local pi = math.pi
local atan2 = math.atan2
local mRand = math.random

local M = {}

M.defaults = {
	parent 	= display.newGroup(),
	x 		= device.centerX/2,
	y 		= device.centerY/2,
	scale 	= 1,
	type 	= 'enemy',
	spawnDur = 4000,
	
	freq 	= 100, -- one out of this chance per frame tat it will move
	speed 	= 1, -- angle of movement gets divided by this, so the smaller it is, the faster the object moves
	scaleFactor = 0.25
}

local function spawn( obj )
	obj.alpha = 1
	local pd = require ( "assets.characters." .. 'micro' .. ".physics_defs" ).physicsData( obj.scaleFactor/2 )
	physics.addBody( obj, 'dynamic', pd:get( obj.type .. '_' ..obj.species ) )

	obj.density = 10
	obj.linearDamping = 3

	if obj.type == 'food' then 
		gd.level_stats.food_count = gd.level_stats.food_count + 1 
	end
	obj.status = 'live'

end

function M:new( args )
	
	-- fill in any missing args from module defaults
	if args == nil then args = M.defaults end
	for key, value in pairs( M.defaults ) do
		args[key] = args[key] or M.defaults[key]
	end

	local species = 'wanderer'

	local wanderer = display.newImage( args.parent, args.parent.char_sheet, args.parent.char_sheet_info:getFrameIndex( args.type .. '_' .. species ) )
	
	wanderer.type = args.type
	wanderer.freq = args.freq
	wanderer.speed = args.speed

	wanderer.scaleFactor = args.scaleFactor

	wanderer.species = species

	wanderer.x = args.x
	wanderer.y = args.y

	wanderer.status = 'spawning'

	wanderer:scale( 0.01, 0.01 )
	
	wanderer.alpha = 0

	wanderer.rotation = mRand( 360 )
	local rotate_to = mRand( 360 )
	
	transition.to( wanderer, { time=args.spawnDur, rotation=rotate_to, alpha=0.5, xScale=args.scaleFactor, yScale=args.scaleFactor, onComplete=function() spawn( wanderer ); end } )


	function wanderer:eachFrame( args )

		if self.status == 'dead' or self.status == 'removed' or self.status == 'spawning' then
			return
		end

		local dx = mRand( -self.speed, self.speed )
		local dy = mRand( -self.speed, self.speed )

		local lvx, lvy = self:getLinearVelocity()
		local angle = math.atan2( lvy, lvx )
		angle = ( angle * ( 180 / math.pi ) ) + 90
		self.rotation = angle


		if mRand( self.freq ) <= 1 then
			self:applyLinearImpulse( dx/(1/self.speed), dy/(1/self.speed), self.x, self.y )
		end
	end

	function wanderer:cleanup()
		self:removeSelf()
	end

	return wanderer
end


return M
