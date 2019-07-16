-----------------------------------------------------------------------------------------
--
-- Main Menu
--
-----------------------------------------------------------------------------------------

local Composer = require( "composer" )
local scene = Composer.newScene()

local device = require( 'utilities.device' )

local Btn = require( 'ui.btn' )

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

	ui.settings_btn = Btn:new({
		parent 		= group,
		outline 	= 2,
		outline_radius = 4,
		label 		= "Settings",
		x 			= 40,
		y 			= device.screenHeight-60,
		width 		= 150,
		height 		= 40,
		font 		= 'assets/fonts/press_play.ttf',
		font_size 	= 14,
		color 		= { 1, 1, 1 },
		anchorX 	= 0,
		onPress 	= function() Composer.gotoScene( 'scenes.settings' ); end,
	})



	ui.levels_btn = Btn:new({
		parent 		= group,
		outline 	= 2,
		outline_radius = 4,
		label 		= "Levels",
		x 			= device.centerX,
		y 			= device.screenHeight-60,
		width 		= 150,
		height 		= 40,
		font 		= 'assets/fonts/press_play.ttf',
		font_size 	= 14,
		color 		= { 1, 1, 1 },
		onPress 	= function() Composer.gotoScene( 'scenes.level_select' ); end,
	})



	ui.play_btn = Btn:new({
		parent 		= group,
		outline 	= 2,
		outline_radius = 4,
		label 		= "Play",
		x 			= device.screenWidth - 40,
		y 			= device.screenHeight-60,
		width 		= 150,
		height 		= 40,
		font 		= 'assets/fonts/press_play.ttf',
		font_size 	= 14,
		color 		= { 1, 1, 1 },
		anchorX 	= 1,
		onPress 	= function() Composer.gotoScene( 'scenes.play' ); end,
	})

	


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