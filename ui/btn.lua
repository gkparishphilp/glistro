
-- This module is a simple button creator
-- it uses rounded rectangle to create buttons from circles to rectangles
-- buttons can include a lable and/or an icon (icons require fontawesome module)
-- can someday extend to include an image or image-sheet


-- use via: 
-- Btn = require( "ui.btn" )
-- my_btn = Btn:new({ my_opts })

-- Here are all available opts so far...

-- onRelease 		= function to call when button is pressed
-- x 				= x coordinate for btn group
-- y 				= y coordinate for btn group
-- anchorX 			= x anchor for btn group
-- anchorY 			= y anchor for btn group
-- width 			= width of btn
-- height 			= height of btn
-- label 			= text to display 
-- label_x 			= x coord for label txt (defaults to btn center)
-- label_y 			= y coord for label txt (defaults to btn center)
-- font 			= font to use for label
-- outline 			= border radius to draw outline container (0 for no container)
-- outline_radius 	= corner radius for border (half height for circle)
-- icon 			= icon to include (font awesome)
-- icon_x  			= x coord for icon (defaults to btn center if no label, 33% left if label)
-- icon_y 			= y coord for icon (defaults to btn center)
-- color 			= color (defaults to border, font & icon)
-- press_color 		= color when button pressed 
-- bg_color 		= color of button bg (if border > 0)
-- press_bg_color 	= color of button bg (if border > 0)	
-- outline_color
-- press_outline_color

---------------------------------------------------------------------------------
-- "Globals"
---------------------------------------------------------------------------------
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenTop = display.screenOriginY
local screenLeft = display.screenOriginX
local screenBottom = display.screenOriginY + display.actualContentHeight
local screenRight = display.screenOriginX + display.actualContentWidth
local screenWidth = screenRight - screenLeft
local screenHeight = screenBottom - screenTop

-- Table to hold everything
local M = {}

-- Default opts
M.defaults = {
	font 			= 'Helvetica',
	x 				= centerX,
	y 				= centerY,
	anchorX 		= 0.5,
	anchorY 		= 0.5,
	width 			= 40,
	height 			= 40,
	outline 		= 2,
	color 			= { 0.5, 0.5, 0.99, 1 },
	press_color 	= { .88, .88, .88, 1 },
	bg_color 		= { 0, 0, 0, 1 },
	bg_press_color 	= { 0, 0, 0, 1 }

}

-- Create an instance
function M:new( opts )
	if opts == nil then opts = M.defaults end

	-- passing in a theme sets font and colors by default (opts should over-ride)
	local theme = nil
	if opts.theme_name then
		theme = require( 'ui.themes.' .. opts.theme_name )
	elseif opts.theme then
		theme = opts.theme
	end


	if theme then
		opts.font = opts.font or theme.font

		opts.outline = opts.outline or theme.btn_outline

		opts.color = opts.color or theme.colors.font
		opts.press_color = opts.press_color or theme.colors.font_press

		opts.bg_color = opts.bg_color or theme.colors.btn_bg
		opts.bg_press_color = opts.bg_press_color or theme.colors.btn_bg_press

		opts.outline_color = opts.outline_color or theme.colors.btn_outline
		opts.outline_press_color = opts.outline_press_color or theme.colors.btn_outline_press
	end
	
	-- fill in any missing opts from module defaults
	for key, value in pairs( M.defaults ) do
		opts[key] = opts[key] or M.defaults[key]
	end
	opts.font_size = opts.font_size or opts.height / 3

	-- can position the label or defaults to button center
	opts.label_x = opts.label_x or opts.x
	opts.label_y = opts.label_y or opts.y

	-- can position icon, or defaults to button center if no label, left if label present
	if opts.label then
		opts.icon_x = opts.icon_x or opts.x - opts.width * 0.33
	else	
		opts.icon_x = opts.icon_x or opts.x
	end
	opts.icon_y = opts.icon_y or opts.y

	-- can set icon size, or defaults to smaller if label, larger if no label
	if opts.label then
		opts.icon_size = opts.icon_size or opts.height / 3
	else 
		opts.icon_size = opts.icon_size or opts.height / 2
	end

	-- can set radius ( 0 for square, max of 1/2 height for perfectly round )
	opts.outline_radius = opts.outline_radius or opts.height / 2


	-- outline color defaults to primary color
	opts.outline_color = opts.outline_color or opts.color 
	opts.press_outline_color = opts.press_outline_color or opts.press_color 




	local btn = display.newGroup()
	if opts.parent then
		opts.parent:insert( btn )
	end

	btn.anchorX, btn.anchorY = opts.anchorX, opts.anchorY

	if opts.outline >= 0 then
		btn.outline = display.newRoundedRect( btn, opts.x, opts.y, opts.width, opts.height, opts.outline_radius )
		
		if opts.outline > 0 then
			btn.outline.stroke = {type="image", filename="assets/images/brushes/blur_brush1x4.png"}
			btn.outline.strokeWidth = opts.outline
	
			-- this can't be stroke= to get antialiased border
			btn.outline:setStrokeColor( unpack(opts.outline_color ) )
		end

		btn.outline.fill = opts.bg_color
	end

	if opts.label then
		btn.label = display.newText( btn, opts.label, opts.label_x, opts.label_y, opts.font, opts.font_size )
		btn.label.fill =  opts.color
	end

	if opts.icon then
		btn.icon = display.newText( btn, opts.icon, opts.icon_x, opts.icon_y, 'FontAwesome', opts.icon_size )
		btn.icon.fill = opts.color
	end

	function btn:touch( event )
		if event.phase == 'began' then

			 display.getCurrentStage():setFocus( event.target )

			if btn.outline then
				btn.outline:setStrokeColor( unpack( opts.outline_press_color ) )
				btn.outline.fill = opts.bg_press_color
			end
			if btn.label then
				btn.label.fill = opts.press_color
			end
			if btn.icon then
				btn.icon.fill = opts.press_color
			end
		elseif event.phase == 'ended' then
			display.getCurrentStage():setFocus( nil )
			if btn.outline then
				btn.outline:setStrokeColor( unpack( opts.outline_color ) )
				btn.outline.fill = opts.bg_color
			end
			if btn.label then
				btn.label.fill = opts.color
			end
			if btn.icon then
				btn.icon.fill = opts.color
			end
			opts.onRelease()
		elseif event.phase == 'cancelled' then
			display.getCurrentStage():setFocus( nil )
		end
		return true
	end
	btn:addEventListener( 'touch', btn )

	-- make sure to return te thing
	return btn
end

-- make sure to return the module table
return M