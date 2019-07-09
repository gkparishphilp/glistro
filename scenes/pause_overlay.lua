---------------------------------------------------------------------------------
--
-- pause overlay.lua
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Libraries & Modules
---------------------------------------------------------------------------------
local Composer = require( "composer" )
local scene = Composer.newScene()

local gdata = require( 'modules.gdata' )
local device = require( 'utilities.device' )

local Game = require( 'modules.game' ) 

---------------------------------------------------------------------------------
-- Scene Variables
---------------------------------------------------------------------------------
local panel = display.newGroup()
local ui = {}

---------------------------------------------------------------------------------
-- Scene Functions
---------------------------------------------------------------------------------
function scene:create( event )
	local group = self.view

end

function scene:show( event )
	local group = self.view
	local parent = event.parent

	if event.phase == "will" then

		
		panel.frame = display.newRoundedRect( group, device.centerX, device.centerY, device.screenWidth * 0.66, device.screenHeight * 0.66, 6 )
		--panel.frame.anchorX, panel.frame.anchorY = 1, 0
		panel.frame.fill = { 1, 1, 1, 0.66}

		--panel.frame.stroke = {type="image", filename="assets/images/brushes/blur_brush1x4.png"}
		panel.frame.strokeWidth = 4
		panel.frame:setStrokeColor( 1, 1, 1, 1 )

		ui.resume = display.newText({
			parent 	= group,
			text 	= 'Resume',
			font 		= 'assets/fonts/press_play.ttf',
			fontSize 	= 14,
			x 		= device.centerX,
			y 		= device.centerY - 50
		})
		ui.resume.fill = { 0,0,0,1 }
		ui.resume:addEventListener( 'tap', function() Composer.hideOverlay( "slideUp", 400 ) end )
		

		ui.restart = display.newText({
			parent 	= group,
			text 	= 'Restart',
			font 		= 'assets/fonts/press_play.ttf',
			fontSize 	= 14,
			x 		= device.centerX,
			y 		= device.centerY
		})
		ui.restart.fill = { 0,0,0,1 }
		ui.restart:addEventListener( 'tap', function() parent:reset(event); Composer.hideOverlay( "slideUp", 400 ); end )

		ui.quit = display.newText({
			parent 	= group,
			text 	= 'Quit',
			font 		= 'assets/fonts/press_play.ttf',
			fontSize 	= 14,
			x 		= device.centerX,
			y 		= device.centerY + 50
		})
		ui.quit.fill = { 0,0,0,1 }
		ui.quit:addEventListener( 'tap', function() Composer.gotoScene( "scenes.main_menu" ) end )
		

		group:insert( panel )

	elseif event.phase == "did" then
		Composer.setVariable( 'overlay', true )
	end
	
end

function scene:hide( event )
	local parent = event.parent

	if event.phase == "will" then
		parent:resume_game()
	elseif event.phase == "did" then
		Composer.setVariable( 'overlay', false )
	end
	
end

function scene:destroy( event )

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene