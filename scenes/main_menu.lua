-----------------------------------------------------------------------------------------
--
-- Main Menu
--
-----------------------------------------------------------------------------------------

local Composer = require( "composer" )
local scene = Composer.newScene()

local device = require( 'utilities.device' )

--------------------------------------------

-- forward declarations and other locals
local ui = {}


function scene:create( event )
	local group = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	ui.title = display.newText({
		parent 		= group,
		text 		= "Glistro",
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= 28,
		x 			= device.centerX,
		y 			= device.screenHeight * 0.15,
	})

	
	ui.settings_btn = display.newRoundedRect( group, 20, device.screenHeight - 60, 150, 40, 4 )
	ui.settings_btn.anchorX = 0
	ui.settings_btn.fill = { 0,0,0,1 }
	ui.settings_btn:setStrokeColor( 1, 1, 1, 0.5 )
	ui.settings_btn.strokeWidth = 2

	ui.settings_lbl = display.newText({
		parent 		= group,
		text 		= "Settings",
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= 14,
		x 			= 40,
		y 			= device.screenHeight - 60,
	})
	ui.settings_lbl.anchorX = 0
	function ui.settings_btn:touch( e )
		if e.phase == 'began' then
			Composer.gotoScene( 'scenes.settings' )
		end
	end
	ui.settings_btn:addEventListener( 'touch', ui.settings_btn )


	ui.play_btn = display.newRoundedRect( group, device.screenWidth-20, device.screenHeight - 60, 150, 40, 4 )
	ui.play_btn.anchorX = 1
	ui.play_btn.fill = { 0,0,0,1 }
	ui.play_btn:setStrokeColor( 1, 1, 1, 0.5 )
	ui.play_btn.strokeWidth = 2
	ui.play_lbl = display.newText({
		parent 		= group,
		text 		= "Play",
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= 14,
		x 			= device.screenWidth - 95,
		y 			= device.screenHeight - 60,
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