
-- This module creates a set of buttons
-- if the set is larger than the screen, it pages and scrolls on swipe

-- use via: 
-- BtnSet = require( "ui.btn_set" )
-- my_btn_set = BtnSet:new({ my_args })

-- Here are all available args so far...


---------------------------------------------------------------------------------
-- "Globals"
---------------------------------------------------------------------------------
local device = require( 'utilities.device' )
local Btn = require( 'ui.btn' )
local Debug = require( 'utilities.debug' )

-- Table to hold everything
local M = {}

-- Default args
M.defaults = {

}

-- Create an instance
function M:new( args )
	if args == nil then args = M.defaults end

	-- fill in any missing args from module defaults
	for key, value in pairs( M.defaults ) do
		args[key] = args[key] or M.defaults[key]
	end

	-- print( "set args: " )
	-- Debug.print_table( args )
	

	local set = display.newGroup()
	set.anchorChildren = true 
	
	if args.parent then
		args.parent:insert( set )
	end


	-- make sure to return te thing
	return set
end

-- make sure to return the module table
return M