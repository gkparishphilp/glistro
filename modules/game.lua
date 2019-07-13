

local mRand = math.random
local mFloor = math.floor
local mSqrt = math.sqrt


local physics = require( 'physics' )
local Composer = require( "composer" )

local Sound = require( 'modules.sound' )
local Clock = require( 'modules.clock' )

local Hud = require( 'modules.hud' )
local Level = require( 'modules.level' )
local settings = require( 'modules.settings' )

local gd = require( 'modules.gdata' )
local device = require( 'utilities.device' )


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

	local game = display.newGroup()
	args.parent:insert( game )

	
	game.level = Level:new({
		parent = game
	})

	game.hud = Hud:new({
		parent = game
	})
	game.hud.pause_btn:addEventListener( 'tap', function() 
			game:pause(); 
			Composer.showOverlay( 'scenes.pause_overlay', { effect='fromTop', time=500, isModal=true } )
	 	end )

	local physicsMode = 'normal' -- 'hybrid' -- 'normal' 'debug'
	physics.start()
	physics.pause()
	physics.setGravity( 0, 0 )
	physics.setDrawMode( physicsMode )




	function game:cleanup()
		transition.cancel()

		self.level:cleanup()
		self.level = nil

		self.hud:cleanup()
		self.hud = nil

		self:removeSelf()
		--self = nil
	end


	function game.collision( e )
		if e.phase == 'began' then
			print( 'hit ' .. e.other.type .. ' ' .. e.other.species )
			if e.other.type == 'food' then
				if e.other.status ~= 'dead' then
					---print( 'ate a food' )
				
					Sound.playSound( Sound.fx.eat )

					e.other.isVisible = false
					gd.level_stats.score = gd.level_stats.score + 1
					gd.session_stats.score = gd.session_stats.score + 1
					gd.level_stats.eaten_count = gd.level_stats.eaten_count + 1
					if gd.level_stats.eaten_count == gd.level_stats.food_count then
						gd.game_state = 'complete'
						game:end_level()
					end
					e.other.status = 'dead'
				end
			elseif e.other.type == 'inert' then
				--print( 'hit a structure' )
				Sound.playSound( Sound.fx.hit )
				gd.level_stats.collision_count = gd.level_stats.collision_count + 1
			elseif e.other.type == 'enemy' then
				--print( 'hit an enemy' )
				--self:setLinearVelocity( 0, 0 )
				gd.game_state = 'dead'
				game:end_level()
			else
				--print( 'hit a ' .. e.other.type )
			end
		end
	end


	function game:countIn(  )
		local countInClock = Clock:new({
			group 		= game,
			font 		= 'assets/fonts/press_play.ttf',
			startAt 	= 4000,
			showMins 	= false,
			endAt 		= 0,
			fontSize 	= device.screenHeight/3,
			fontFill 	= { 1, 1, 1, 1 },
			secFormat 	= "%01d",
			endMsg 		= 'Go!'

		})
		countInClock:start()
		countInClock:addEventListener( 'timesUp', function() countInClock.isVisible=false; countInClock:cleanup(); countInClock=nil; game:start() end )
	end


	function game:end_level()
		
		self.hud.clock:pause()
		physics.pause()

		gd.level_stats.elapsed_time = game.hud.clock.elapsedTime

		if gd.game_state == 'complete' then
			gd.cur_level = gd.cur_level + 1
			if math.floor( gd.level_stats.elapsed_time / 1000 ) < gd.level_stats.target_time then
				gd.level_stats.time_bonus =  gd.level_stats.target_time - math.floor( gd.level_stats.elapsed_time / 1000 )
				gd.session_stats.score = gd.session_stats.score + gd.level_stats.time_bonus
			end

			if gd.level_stats.collision_count <  gd.level_stats.target_collisions then
				gd.level_stats.collision_bonus = (  gd.level_stats.target_collisions - gd.level_stats.collision_count ) * 10
				gd.session_stats.score = gd.session_stats.score + gd.level_stats.collision_bonus
			end

			gd.update_session_stats()
			gd.update_total_stats()
		end

		Composer.gotoScene( 'scenes.level_summary' )
	end


	function game:enterFrame( e )
		if gd.game_state == 'active' and game.level then

			-- update viewport to cebter-track the hero
			if game.level.w > device.actualContentWidth then
				game.level.x = device.centerX - game.level.hero.x
				if game.level.x < game.minViewX then game.level.x = game.minViewX end
				if game.level.x > game.maxViewX then game.level.x = game.maxViewX end
			end

			if game.level.h > device.actualContentHeight then
				game.level.y = device.centerY - game.level.hero.y + self.hud.h / 2
				if game.level.y < game.minViewY then game.level.y = game.minViewY end
				if game.level.y > game.maxViewY then game.level.y = game.maxViewY end
			end
			

			

			--move/animate all the things
			for i=1, #game.level.objects do
				if game.level.objects[i].status ~= 'dead' then
					game.level.objects[i]:eachFrame( { heroX=self.level.hero.x, heroY=self.level.hero.y } )
				else
					game.level.objects[i].status = 'removed'
					physics.removeBody( game.level.objects[i] )
					--game.level.characters[i]:removeSelf()
				end
			end

		end
	end
	Runtime:addEventListener( 'enterFrame', game )

	function game:pause()
		gd.game_state = 'paused'
		audio.pause()
		self.hud.clock:pause()
		physics.pause()
	end

	function game:resume()
		gd.game_state = 'active'
		audio.resume()
		self.hud.clock:start()
		physics.start()
	end

	function game:start()
		gd.game_state = 'active'
		self.hud.clock:start()
		physics.start()
	end

	function game:setup( args )
		defaults = { cur_mode = 'playnow', cur_level = 1 }
		if args == nil then args = defaults end
		for key, value in pairs( defaults ) do
			args[key] = args[key] or defaults[key]
		end

		gd.game_state = 'pending'

		-- reset per-level global data
		gd.reset_level_stats()

		self.level:setup()

		self.minViewX = self.level.x - (self.level.w / 2 ) + ( device.actualContentWidth / 4 ) + 80
		self.maxViewX = self.level.x + ( self.level.w / 2 )  - ( device.actualContentWidth / 4 ) - 80
		--print( "minViewX=" .. self.minViewX .. " maxViewX=" .. self.maxViewX )

		self.minViewY = self.level.y - (self.level.h / 2 ) + ( device.actualContentHeight / 4 ) 
		self.maxViewY= self.level.y + ( self.level.h / 2 )  - ( device.actualContentHeight / 4 ) - self.hud.h /2
		--print( "minViewY=" .. self.minViewY .. " maxViewY=" .. self.maxViewY )

		Sound.playMusic( Sound.music[game.level.music] )

		-- Add event listeners for the game.....
		self:addEventListener( 'touch', self )
		-- add hero collision listener
		self.level.hero:addEventListener( 'collision', self.collision )

		self.hud.clock:addEventListener( 'tock', function() self.level:tock({ secs = self.hud.clock.elapsedSeconds, heroX=self.level.hero.x, heroY=self.level.hero.y }); end )


	end

	function game:touch( e )
		if gd.game_state == 'active' then
			game.level.hero:move( e ); 
		end
	end 
	



	return game

end

return M