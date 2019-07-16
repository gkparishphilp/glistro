

local mRand = math.random
local mFloor = math.floor
local mSqrt = math.sqrt

local Hero = require( 'modules.hero' )
local Block = require( 'modules.block' )
local Floater = require( 'modules.floater' )
local Follower = require( 'modules.follower' )
local Wall = require( 'modules.wall' )
local Wanderer = require( 'modules.wanderer' )
local Powerup = require( 'modules.powerup' )


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
			if args.species == 'circle' then params[i].w = params[i].w / 2 end
			params[i].h = params[i].h or params[i].w
			if params[i].x == nil then
				--print( 'generating rand xy pos.... ')
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
			if args.species == 'block' then 
				self.objects[#self.objects + 1] = Block:new({ parent=self, type=args.type, x=params[k].x, y=params[k].y, width=params[k].w, height=params[k].h, spawnDur=args.spawnDur, freq=args.freq, speed=args.speed, scaleFactor=args.scaleFactor })
			elseif args.species == 'floater' then
				self.objects[#self.objects + 1] = Floater:new({ parent=self, type=args.type, x=params[k].x, y=params[k].y, size=params[k].w, spawnDur=args.spawnDur, freq=args.freq, speed=args.speed })
			elseif args.species == 'follower' then
				self.objects[#self.objects + 1] = Follower:new({ parent=self, type=args.type, x=params[k].x, y=params[k].y, scaleFactor=args.scaleFactor, spawnDur=args.spawnDur, freq=args.freq, speed=args.speed })
			elseif args.species == 'wall' then
				self.objects[#self.objects + 1] = Wall:new({ parent=self, type=args.type, x=params[k].x, y=params[k].y, w=params[k].w, h=params[k].h, spawnDur=args.spawnDur, texture=args.texture })
			elseif args.species == 'wanderer' then
				self.objects[#self.objects + 1] = Wanderer:new({ parent=self, type=args.type, x=params[k].x, y=params[k].y, size=params[k].w, spawnDur=args.spawnDur, freq=args.freq, speed=args.speed, scaleFactor=args.scaleFactor })
			end
		end


		

	end


	function level:setup()
		self.data = nil
		print( "requiring: " .. 'levels.' .. gd.cur_mode .. '.' .. gd.cur_level )
		self.data = require( 'levels.' .. gd.cur_mode .. '.' .. gd.cur_level )

		self.w = self.data.w
		self.h = self.data.h

		self.music = self.data.music

		self.char_sheet_info = require( "assets.characters." .. 'micro' .. ".char_sheet" )
		self.char_sheet = graphics.newImageSheet( "assets/characters/" .. 'micro' .. "/char_sheet.png", self.char_sheet_info:getSheet() )

		self:draw_geometry()

		-- update viewport to center-track the hero
		self.x = device.centerX - self.data.heroX
		self.y = device.centerY - self.data.heroY + self.parent.hud.h / 2


		self.hero = Hero:new({ 
			parent		= level,
			x 			= self.data.heroX,
			y 			= self.data.heroY,
			scaleFactor = 0.75
		})

		gd.level_stats.target_collisions = self.data.target_collisions
		gd.level_stats.target_time = self.data.target_time

		if self.data.spawns['0'] then
			for i=1, #self.data.spawns['0'] do
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

		-- top wall
		self:add({ type='inert', species='wall', x=self.data.w/2, y=-self.data.wallWidth/2, w=self.data.w, h=self.data.wallWidth, texture=self.data.wallFill })
		-- bottom wall
		self:add({ type='inert', species='wall', x=self.data.w/2, y=self.data.h+self.data.wallWidth/2, w=self.data.w, h=self.data.wallWidth, texture=self.data.wallFill })
		-- left wall
		self:add({ type='inert', species='wall', x=-self.data.wallWidth/2, y=self.data.h/2, w=self.data.wallWidth, h=self.data.h + (2*self.data.wallWidth), texture=self.data.wallFill })
		-- right wall
		self:add({ type='inert', species='wall', x=self.data.w + self.data.wallWidth/2, y=self.data.h/2, w=self.data.wallWidth, h=self.data.h + (2*self.data.wallWidth), texture=self.data.wallFill })

		
	end

	function level:tock( args )
		--print( "Tock.... at " .. args.secs .. " secs, level.x = " .. self.x .. " level.y = " .. self.y )
		if self.data.spawns[tostring( args.secs )] then
			for i=1, #self.data.spawns[tostring( args.secs )] do
				--debug.print_table( self.data.spawns[tostring( args.secs )][i] )
				level:add( self.data.spawns[tostring( args.secs )][i] )
			end
		end
	end

	return level
end


return M


