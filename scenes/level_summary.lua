-----------------------------------------------------------------------------------------
--
-- Main Menu
--
-----------------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- "Globals"
---------------------------------------------------------------------------------
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenTop = display.screenOriginY
local screenLeft = display.screenOriginX
local screenBottom = display.screenOriginY + display.actualContentHeight
local screenRight = display.screenOriginX + display.actualContentWidth
local screenWidth = screenRight - screenLeft
local screenHeight = screenBottom - screenTop

local gd = require( 'modules.gdata' )
local Sound = require( 'modules.sound' )
local Clock = require( 'modules.clock' )

local Composer = require( "composer" )
local scene = Composer.newScene()

--------------------------------------------

-- forward declarations and other locals
local ui = {}
local die_sound, levelup_sound

function scene:create( event )
	local group = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	
	ui.title = display.newText({
		parent 		= group,
		text 		= "",
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= 28,
		x 			= centerX,
		y 			= screenHeight * 0.33,
	})


	ui.stat_score = display.newText({
		parent 		= group,
		text 		= "Score: ",
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= 12,
		x 			= centerX,
		y 			= screenHeight * 0.5,
	})

	ui.stat_time = display.newText({
		parent 		= group,
		text 		= "Time: ",
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= 12,
		x 			= centerX,
		y 			= screenHeight * 0.5 + 50,
	})


	
	ui.quit_btn = display.newText({
		parent 		= group,
		text 		= "Quit",
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= 14,
		x 			= 40,
		y 			= screenHeight - 40,
	})
	ui.quit_btn.anchorX = 0
	function ui.quit_btn:touch( e )
		if e.phase == 'began' then
			gd.cur_level = 1
			Composer.gotoScene( 'scenes.main_menu' )
		end
	end
	ui.quit_btn:addEventListener( 'touch', ui.quit_btn )


	ui.play_btn = display.newText({
		parent 		= group,
		text 		= "Next",
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= 14,
		x 			= screenWidth -40,
		y 			= screenHeight - 40,
	})
	ui.play_btn.anchorX = 1
	function ui.play_btn:touch( e )
		if e.phase == 'began' then
			Composer.gotoScene( 'scenes.play' )
		end
	end
	ui.play_btn:addEventListener( 'touch', ui.play_btn )

	
end

function scene:show( event )
	local group = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

		--audio.fadeOut( { channel=1, time=500 } )
		audio.stop()

		ui.stat_score.text = "Score: " .. gd.total_stats.score
		
		ui.stat_time.text = "Time: " .. Clock.humanizeTime( { time = gd.level_stats.elapsed_time } )
		if gd.level_stats.time_bonus > 0 then
			ui.stat_time.text = ui.stat_time.text ..'\n\n+' .. gd.level_stats.time_bonus .. 'pts Time Bonus!'
		end

		if gd.level_stats.collision_bonus > 0 then
			ui.stat_time.text = ui.stat_time.text ..'\n\n+' .. gd.level_stats.collision_bonus .. 'pts Clean Run!'
		end
		
		if gd.game_state == 'complete' then
			ui.title.text = "Level Complete!"
			ui.play_btn.text = 'Next'
			--Sound.playSound( Sound.fx.levelup )
		else
			ui.title.text = "You Died :("
			ui.play_btn.text = 'Replay'
			--Sound.playSound( Sound.fx.die )
		end

	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local group = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local group = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene