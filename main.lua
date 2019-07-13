-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local gdata = require( 'modules.gdata' )
local device = require( 'utilities.device' )
local debugger = require( 'utilities.debug' )


print("-----------------------------------")
print "Starting up Glistro.... Here we go!"
print("-----------------------------------")

-- Seed the random number generator
math.randomseed( os.time() )

-- print( "gData Table:")
-- debugger.print_table( gdata )

-- print( "Device Table:")
-- debugger.print_table( device )


-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

local FileUtils = require( 'utilities.file' )

local settings = require( 'modules.settings' )
-- initialize users settings
local saved_settings = FileUtils.loadTable( "settings.json" )

--debugger.print_table( saved_settings )

-- have to initialize settings in case file doesn't exist
-- fill in any missing args from module defaults
if saved_settings == nil then saved_settings = {} end
for key, value in pairs( settings.defaults ) do
	settings[key] = saved_settings[key] or settings.defaults[key]
end

-- include the Corona "composer" module
local Composer = require "composer"


-- load menu screen
Composer.gotoScene( "scenes.main_menu" )

--local meter = debugger:newPerformanceMeter()