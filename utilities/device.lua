
-- This is the device data for the app 
-- It includes all environment data such as screenWidth, etc

local sysInfo = system.getInfo

local M = {}



M.contentWidth 	= display.contentWidth
M.cWidth 		= display.contentWidth

M.contentHeight = display.contentHeight
M.cHeight 		= display.contentHeight

M.centerX 		= display.contentCenterX
M.cX 			= display.contentCenterX

M.centerY 		= display.contentCenterY
M.cY 			= display.contentCenterY


M.originX 		= display.screenOriginX
M.oX 			= display.screenOriginX

M.originY 		= display.screenOriginY
M.oY 			= display.screenOriginY

M.actualContentWidth 	= display.actualContentWidth
M.aCW 					= display.actualContentWidth

M.actualContentHeight 	= display.actualContentHeight
M.aCH 					= display.actualContentHeight

M.safeOriginX 	= display.safeScreenOriginX
M.safeOX 		= display.safeScreenOriginX

M.safeOriginY 	= display.safeScreenOriginY
M.safeOY 		= display.safeScreenOriginY

M.safeActualContentWidth 	= display.safeActualContentWidth
M.safeACW 					= display.actualContentWidth

M.actualContentHeight 		= display.safeActualContentHeight
M.safeACH 					= display.safeActualContentHeight


M.screenTop = display.screenOriginY
M.screenBottom = display.screenOriginY + display.actualContentHeight

M.screenLeft = display.screenOriginX
M.screenRight = display.screenOriginX + display.actualContentWidth

M.screenWidth =  M.screenRight - M.screenLeft
M.screenHeight = M.screenBottom - M.screenTop



local model = sysInfo( "model" )


-- Are we on the Simulator?
M.isSimulator = false
if (  sysInfo( "environment" ) == "simulator" ) then
	M.isSimulator = true
end

-- Is this a tall device?
M.isTall = false
if ( display.pixelHeight/display.pixelWidth > 1.5 ) then
	M.isTall = true
end

-- Now identify the Apple family of devices:
M.isApple = false
M.isAndroid = false
M.isKindleFire = false
M.is_iPad = false
if ( string.sub( model, 1, 2 ) == "iP" ) then 
	-- We are an iOS device of some sort
	M.isApple = true

	if ( string.sub( model, 1, 4 ) == "iPad" ) then
		M.is_iPad = true
	end
else
	 -- Not Apple, so it must be one of the Android devices
	M.isAndroid = true

	-- Let's assume we are on Google Play for the moment
	M.isGoogle = true

	-- All of the Kindles start with "K", although Corona builds before #976 returned
	-- "WFJWI" instead of "KFJWI" (this is now fixed, and our clause handles it regardless)
	if ( model == "Kindle Fire" or model == "WFJWI" or string.sub( model, 1, 2 ) == "KF" ) then
		M.isKindleFire = true
		M.isGoogle = false  --revert Google Play to false
	end

end

return M


