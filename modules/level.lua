

local mRand = math.random
local mFloor = math.floor
local mSqrt = math.sqrt

local Hero = require( 'modules.hero' )
local Circle = require( 'modules.circle' )
local Square = require( 'modules.square' )
local Triangle = require( 'modules.triangle' )
local Diamond = require( 'modules.diamond' )


local physics = require( 'physics' )
local device = require( 'utilities.device' )
local gd = require( 'modules.gdata' )

local debug = require( 'utilities.debug' )


local function distance( obj1, obj2 )
	local dx = obj1.x - obj2.x
    local dy = obj1.y - obj2.y
 
    return mSqrt( dx*dx + dy*dy )
end



local M = {}

M.defaults = {
	parent 	= display.newGroup()
}



function M:new( args )
	
	-- fill in any missing args from module defaults
	if args == nil then args = M.defaults end
	for key, value in pairs( M.defaults ) do
		args[key] = args[key] or M.defaults[key]
	end

	local level = display.newGroup()
	args.parent:insert( level )

	level.objects = {}


	function level:add( args )
		-- args.type == food, inert, enemy 
		-- args.shape == square, circle, triangle
		-- x, y, w, h, speed, freq, spawnDur
		print( 'adding... ' .. args.shape )

		local params = {}
		params[1] = {}

		local count = 1
		if args.count and args.count > 1 then count = args.count end
		params[1].w = args.w
		params[1].h = args.h
		params[1].x = args.x 
		params[1].y = args.y

		for i=1, count do
			-- initialize params for each object 
			-- hopefully new randaom values per count if more than one....
			if i > 1 then params[i] = {} end
			params[i].w = params[i].w or mRand( 5, 22 )
			if args.shape == 'circle' then params[i].w = params[i].w / 2 end
			params[i].h = params[i].h or params[i].w
			if params[i].x == nil then
				print( 'generating rand xy pos.... ')
				repeat
					params[i].x = mRand( params[i].w/2, self.w-(params[i].w/2) )
					params[i].y = mRand( params[i].h/2, self.h-(params[i].h/2) )
				until distance( { x=params[i].x, y=params[i].y }, { x=self.hero.x, y=self.hero.y } ) >= 30
			end
		end

		for k=1, count do
			-- actually add the objects
			-- note that shape, type, freq, speed are set by parent args,
			-- while size & xy are initialized above....
			if args.shape == 'square' then 
				self.objects[#self.objects + 1] = Square:new({ parent=self, type=args.type, x=params[k].x, y=params[k].y, width=params[k].w, height=params[k].h, spawnDur=args.spawnDur, freq=args.freq, speed=args.speed })
			elseif args.shape == 'circle' then
				self.objects[#self.objects + 1] = Circle:new({ parent=self, type=args.type, x=params[k].x, y=params[k].y, size=params[k].w, spawnDur=args.spawnDur, freq=args.freq, speed=args.speed })
			elseif args.shape == 'triangle' then
				self.objects[#self.objects + 1] = Triangle:new({ parent=self, type=args.type, x=params[k].x, y=params[k].y, size=params[k].w, spawnDur=args.spawnDur, freq=args.freq, speed=args.speed })
			end
		end


		

	end


	function level:setup()
		self.data = nil
		print( "requiring: " .. 'levels.' .. gd.cur_mode .. '_' .. gd.cur_level )
		self.data = require( 'levels.' .. gd.cur_mode .. '_' .. gd.cur_level )

		self.w = self.data.w
		self.h = self.data.h

		self.music = self.data.music

		self:draw_geometry()

		self.hero = Hero:new({ 
			parent		= level,
			x 			= self.data.heroX,
			y 			= self.data.heroY,
		})

		gd.level_stats.target_collisions = self.data.target_collisions
		gd.level_stats.target_time = self.data.target_time

		print( "setting up '0' spawns" )

		if self.data.spawns['0'] then
			print( 'got setup spawns')
			print( 'thare are ' .. #self.data.spawns['0'] .. ' row' )
			for i=1, #self.data.spawns['0'] do
				debug.print_table( self.data.spawns['0'][i] )
				level:add( self.data.spawns['0'][i] )
			end
		end

	end


	function level:cleanup()
		self:removeSelf()
	end

	function level:draw_geometry()
		-- create backgrounds & walls from level data
		self.bg = display.newRect( self, 0, 0, self.data.w*4, self.data.h*4 )
		display.setDefault( "textureWrapX", "repeat" )
		display.setDefault( "textureWrapY", "repeat" )
		self.bg.fill = self.data.bg.fill
		self.bg.fill.scaleX = self.data.bg.tx_size / self.bg.contentWidth * self.data.bg.tx_scale
		self.bg.fill.scaleY = self.data.bg.tx_size / self.bg.contentHeight * self.data.bg.tx_scale

		self.arena_bg = display.newRect( self, self.data.w/2, 0, self.data.w, self.data.h )
		self.arena_bg.anchorY = 0
		self.arena_bg.fill = self.data.arena_bg.fill
		self.arena_bg.fill.scaleX = self.data.arena_bg.tx_size / self.arena_bg.contentWidth * self.data.arena_bg.tx_scale
		self.arena_bg.fill.scaleY = self.data.arena_bg.tx_size / self.arena_bg.contentHeight * self.data.arena_bg.tx_scale

		self.walls = {}
		self.walls.top = display.newRect( self, self.data.w/2, 0, self.data.w, self.data.wallWidth )
		self.walls.top.anchorX, self.walls.top.anchorY = 0.5, 1
		physics.addBody( self.walls.top, 'static' )
		self.walls.top.type = 'inert'
		self.walls.top.fill = self.data.wallFill

		self.walls.bottom = display.newRect( self, self.data.w/2, self.data.h, self.data.w, self.data.wallWidth )
		self.walls.bottom.anchorX, self.walls.bottom.anchorY = 0.5, 0
		physics.addBody( self.walls.bottom, 'static' )
		self.walls.bottom.type = 'inert'
		self.walls.bottom.fill = self.data.wallFill

		self.walls.left = display.newRect( self, 0, self.data.h/2, self.data.wallWidth, self.data.h + (2*self.data.wallWidth) )
		self.walls.left.anchorX, self.walls.left.anchorY = 1, 0.5
		physics.addBody( self.walls.left, 'static' )
		self.walls.left.type = 'inert'
		self.walls.left.fill = self.data.wallFill

		self.walls.right = display.newRect( self, self.data.w, self.data.h/2, self.data.wallWidth, self.data.h + (2*self.data.wallWidth) )
		self.walls.right.anchorX, self.walls.right.anchorY = 0, 0.5
		physics.addBody( self.walls.right, 'static' )
		self.walls.right.type = 'inert'
		self.walls.right.fill = self.data.wallFill

		
	end

	function level:tock( args )
		print( 'Level is tocking....' .. args.secs )
		if self.data.spawns[tostring( args.secs )] then
			print( 'got tock spawns')
			print( 'thare are ' .. #self.data.spawns[tostring( args.secs )] .. ' row' )
			for i=1, #self.data.spawns[tostring( args.secs )] do
				debug.print_table( self.data.spawns[tostring( args.secs )][i] )
				level:add( self.data.spawns[tostring( args.secs )][i] )
			end
		end
	end

	return level
end


return M


