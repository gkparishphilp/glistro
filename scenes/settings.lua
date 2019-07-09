-----------------------------------------------------------------------------------------
--
-- Settings
--
-----------------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- "Globals"
---------------------------------------------------------------------------------
local Widget = require( 'widget' )
Widget.setTheme( "widget_theme_ios" ) 

local device = require( 'utilities.device' )
local debug = require( 'utilities.debug' )
local settings = require( 'modules.settings' )

local FileUtils = require( "utilities.file" )

local Composer = require( "composer" )
local scene = Composer.newScene()

--------------------------------------------

-- forward declarations and other locals
local ui = {}
local click


function scene:create( event )
	local group = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	ui.title = display.newText({
		parent 		= group,
		text 		= "Settings",
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


	ui.enter_btn = display.newText({
		parent 		= group,
		text 		= "Enter",
		font 		= 'assets/fonts/press_play.ttf',
		fontSize 	= 14,
		x 			= device.screenWidth - 40,
		y 			= device.screenHeight - 40,
	})
	ui.enter_btn.anchorX = 1
	function ui.enter_btn:touch( e )
		if e.phase == 'began' then
			Composer.gotoScene( 'scenes.main_menu' )
		end
	end
	ui.enter_btn:addEventListener( 'touch', ui.enter_btn )


	click = audio.loadSound( "assets/audio/sounds/click.wav" )


end

function scene:show( event )
	local group = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

		debug.print_table( settings )
		-- The listener for our on/off switch

		local function name_field_handler( event )
			print( "Name field did something" )
			if event.phase == 'began' then

				if event.target.text == 'Your Name' then event.target.text = '' end

			elseif event.phase == 'ended' or event.phase == 'submitted' then
				print( "Name field lost focus... " .. event.target.text )

				native.setKeyboardFocus( nil )
				if event.target.text == '' then 
					event.target.text = "Your Name" 
				end
				
			end
		end


		local function volListener( e )
			
			audio.setVolume( e.target.value / 100 )
			if e.target.value % 10 == 0 then
				audio.play( click )
			end
		end


		ui.fx_vol_label = display.newText({
			parent 		= group,
			text 		= "Fx Volume",
			font 		= 'assets/fonts/press_play.ttf',
			fontSize 	= 14,
			x 			= 100,
			y 			= device.screenHeight / 4 + 30,
		})
		ui.fx_vol_label.anchorY = 0
		ui.fx_vol_label.anchorX = 0

		ui.fx_vol_slider = Widget.newSlider({
			top = device.screenHeight / 4 + 20,
			left = 300,
			width = 200,
			value = settings.fx_vol * 100, 
			listener = volListener
		})
		group:insert( ui.fx_vol_slider )



		ui.music_vol_label = display.newText({
			parent 		= group,
			text 		= "Music Volume",
			font 		= 'assets/fonts/press_play.ttf',
			fontSize 	= 14,
			x 			= 100,
			y 			= device.screenHeight / 4 + 60,
		})
		ui.music_vol_label.anchorY = 0
		ui.music_vol_label.anchorX = 0

		ui.music_vol_slider = Widget.newSlider({
			top = device.screenHeight / 4 + 50,
			left = 300,
			width = 200,
			value = settings.music_vol * 100, 
			listener = volListener
		})
		group:insert( ui.music_vol_slider )



		ui.sense_label = display.newText({
			parent 		= group,
			text 		= "Sensitivity",
			font 		= 'assets/fonts/press_play.ttf',
			fontSize 	= 14,
			x 			= 100,
			y 			= device.screenHeight / 3 + 60,
		})
		ui.sense_label.anchorY = 0
		ui.sense_label.anchorX = 0

		ui.sense_slider = Widget.newSlider({
			top = device.screenHeight / 3 + 50,
			left = 300,
			width = 200,
			value = settings.sensitivity, --user_settings.sensitivity * 100, 
		})
		group:insert( ui.sense_slider )



		local tHeight = 25
		--if device.isAndroid then tHeight = 40 end		-- adjust for Android

		ui.name_field = native.newTextField( 280, 80, 240, tHeight )
		ui.name_field:addEventListener( "userInput", name_field_handler )
		group:insert( ui.name_field )

		ui.name_field.font = native.newFont( 'assets/fonts/press_play.ttf', 16 )
		ui.name_field.text = settings.name or 'Your Name'
		ui.name_field.isVisible = false
		ui.name_field.anchorX = 0
		ui.name_field.x = 100
		ui.name_field.y = 240
		ui.name_field.isVisible = true


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
		native.setKeyboardFocus( nil )

		if ( ui.name_field.text == 'Your Name' ) then ui.name_field.text = nil end
		if ( ui.sense_slider.value == 0 ) then ui.sense_slider.value = 0.33 end

		settings.name 	= ui.name_field.text or settings.name
		settings.music_vol 	= ui.music_vol_slider.value / 100
		settings.fx_vol	= ui.fx_vol_slider.value / 100
		settings.sensitivity = ui.sense_slider.value
		

		FileUtils.saveTable( settings, "settings.json" )

		ui.name_field:removeSelf()
		ui.name_field = nil

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

	audio.dispose( click )
	
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene