
local physics = require( 'physics' )
local device = require( 'utilities.device' )

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
	
	freq 	= 1000, -- one out of this chance per frame tat it will move
	speed 	= 1 -- angle of movement gets divided by this, so the smaller it is, the faster the object moves
}

local function spawn( obj )
	obj.alpha = 1
	local pd = require ( "assets.characters." .. 'micro' .. ".physics_defs" ).physicsData( obj.scaleFactor/2 )
	physics.addBody( obj, 'dynamic', pd:get( obj.type .. '_' ..obj.species ) )
	if obj.type == 'food' then 
		gd.level_stats.food_count = gd.level_stats.food_count + 1 
	end
	obj.linearDamping = 3
	obj.status = 'live'

end

function M:new( args )
	
	-- fill in any missing args from module defaults
	if args == nil then args = M.defaults end
	for key, value in pairs( M.defaults ) do
		args[key] = args[key] or M.defaults[key]
	end

	local species = 'follower'
	
	--local follower = display.newImageRect( args.parent, 'assets/characters/spacecow/enemy.png', 128, 128 )

	local follower = display.newImage( args.parent, args.parent.char_sheet, args.parent.char_sheet_info:getFrameIndex( args.type .. '_' .. species ) )
	
	follower.type = args.type
	follower.freq = args.freq
	follower.speed = args.speed

	follower.scaleFactor = args.scaleFactor

	follower.species = species

	follower.x = args.x
	follower.y = args.y

	follower.status = 'spawning'

	follower:scale( 0.01, 0.01 )
	
	follower.alpha = 0

	transition.to( follower, { time=args.spawnDur, alpha=0.67, xScale=args.scaleFactor, yScale=args.scaleFactor, onComplete=function() spawn( follower ); end } )


	function follower:eachFrame( args )

		if self.status == 'dead' or self.status == 'removed' or self.status == 'spawning' then
			return
		end

		local dx = args.heroX - self.x
		local dy = args.heroY - self.y
		local angle = atan2( dy, dx )
		angle = angle * ( 180 / pi ) - 45

		if self.type == 'food' then
			angle = angle + 180
			dx = -dx
			dy = -dy
		end

		self.rotation = angle - 45

		if mRand( self.freq ) <= 10 then
			self:applyLinearImpulse( dx/(1/self.speed), dy/(1/self.speed), self.x, self.y )
		end
	end

	function follower:cleanup()
		self:removeSelf()
	end

	return follower
end


return M
