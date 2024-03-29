
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
	
	freq 	= 500, -- one out of this chance per frame tat it will move
	speed 	= 20000 -- angle of movement gets divided by this, so the smaller it is, the faster the object moves
}

local function spawn( obj )
	obj.alpha = 1
	local pd = require ( 'assets.characters.spacecow.enemy' ).physicsData( obj.scaleFactor )
	physics.addBody( obj, 'dynamic', pd:get('enemy') )
	obj.status = 'live'

end

function M:new( args )
	
	-- fill in any missing args from module defaults
	if args == nil then args = M.defaults end
	for key, value in pairs( M.defaults ) do
		args[key] = args[key] or M.defaults[key]
	end


	
	local triangle = display.newImageRect( args.parent, 'assets/characters/spacecow/enemy.png', 512, 512 )
	
	triangle.type = args.type
	triangle.freq = args.freq
	triangle.speed = args.speed

	triangle.scaleFactor = args.scaleFactor

	triangle.x = args.x
	triangle.y = args.y

	triangle.status = 'spawning'

	triangle:scale( 0.01, 0.01 )
	
	if args.type == 'inert' then
		triangle.fill = { 0, 0, 1, 1 }
		--triangle.stroke = { 0.5, 0.5, 1, 1 }
	elseif args.type == 'food' then
		--triangle.fill = { 0, 1, 0, 1 }
		--triangle.stroke = { 0.5, 1, 0.5, 1 }
		triangle.frequency = 100
	elseif args.type == 'cue' then
		--triangle.fill = { 0.75, 0.75, 0.75, 1 }
		--triangle.stroke = { 0.33, 0.33, 0.33, 1 }
	elseif args.type == 'enemy' then
		--triangle.fill = { 1, 0, 0, 1 }
		--triangle.stroke = { 1, 0.5, 0.5, 1 }
	end

	-- display.setDefault( "textureWrapX", "repeat" )
	-- display.setDefault( "textureWrapY", "repeat" )
	-- triangle.fill = { type="image", filename='assets/images/characters/enemy.png' }

	--triangle.strokeWidth = 1
	triangle.alpha = 0


	--transition.to( mask, { time=args.spawnDur, xScale=1, yScale=1, onComplete=function() mask:removeSelf(); mask=nil; end } )
	transition.to( triangle, { time=args.spawnDur, alpha=0.5, xScale=args.scaleFactor, yScale=args.scaleFactor, onComplete=function() spawn( triangle ); end } )


	function triangle:eachFrame( args )

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

	function triangle:cleanup()
		self:removeSelf()
	end

	return triangle
end


return M
