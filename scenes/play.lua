-----------------------------------------------------------------------------------------
--
-- Main Menu
--
-----------------------------------------------------------------------------------------

local Composer = require( "composer" )
local scene = Composer.newScene()

local Game = require( 'modules.game' )
local gd = require( 'modules.gdata' )

local game

--------------------------------------------

-- forward declarations and other locals
local ui = {}

function scene:reset(e)
	game:cleanup()
	self:show(e)
end

function scene:create( event )
	local group = self.view

end

function scene:resume_game()
	game:resume()
end

function scene:show( event )
	local group = self.view
	local phase = event.phase
	
	if phase == "will" then
		game = Game:new({
			parent = group
		})
		group.game = game
		game:setup()
		game:countIn()
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
		game:cleanup()
	elseif phase == "did" then
		game = nil
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