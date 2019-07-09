
-- user settings file for things like 
-- audio preferences, name, etc...

local FileUtils = require( "utilities.file" )

local M = {}

-- defaults
M.defaults = { name = 'Your Name', music_vol =0.75, fx_vol = 0.75, sensitivity = 50 }


return M