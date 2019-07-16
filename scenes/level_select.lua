-----------------------------------------------------------------------------------------
--
-- Level Select
--
-----------------------------------------------------------------------------------------

local gd = require( 'modules.gdata' )
local device = require( 'utilities.device' )

local Composer = require( "composer" )
local scene = Composer.newScene()

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
		text 		= "Levels",
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= 28,
		x 			= device.centerX,
		y 			= device.screenHeight * 0.15,
	})

	ui.back_btn = display.newText({
		parent 		= group,
		text 		= "Back",
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= 14,
		x 			= 40,
		y 			= device.screenHeight - 40,
	})
	ui.back_btn.anchorX = 0
	function ui.back_btn:touch( e )
		if e.phase == 'began' then
			Composer.gotoScene( 'scenes.main_menu' )
		end
	end
	ui.back_btn:addEventListener( 'touch', ui.back_btn )


	
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