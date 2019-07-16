
-- This module is a simple button creator
-- it uses rounded rectangle to create buttons from circles to rectangles
-- buttons can include a lable and/or an icon (icons require fontawesome module)
-- can someday extend to include an image or image-sheet


-- use via: 
-- Btn = require( "ui.btn" )
-- my_btn = Btn:new({ my_opts })

-- Here are all available opts so far...

-- onPress 		= function to call when button is pressed
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
-- outline 			= border width to draw outline container (0 for no outline, -1 for no container)
-- outline_radius 	= corner radius for border (half height for circle)
-- color 			= color (defaults to border, font & icon)
-- press_color 		= color when button pressed 
-- bg_color 		= color of button bg (if border > -1)
-- bg_press_color 	= color of button bg (if border > -1)
-- outline_color 		= color of button outline (if border > 0)
-- outline_press_color 	= color of button outline (if border > 0)	


---------------------------------------------------------------------------------
-- "Globals"
---------------------------------------------------------------------------------
local device = require 'utilities.device'
local Debug = require( 'utilities.debug' )


-- Table to hold everything
local M = {}

-- Default opts
M.defaults = {
	font 			= 'Helvetica',
	font_size 		= 12,
	x 				= device.centerX,
	y 				= device.centerY,
	anchorX 		= 0.5,
	anchorY 		= 0.5,
	outline 		= 2,
	color 			= { 1, 1, 1, 1 },
	press_color 	= { 0.88, 0.88, 0.88, 1 },
	bg_color 		= { 0, 0, 0, 1 },
	bg_press_color 	= { 0.15, 0.15, 0.15, 1 },

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

	-- print( "btn opts: " )
	-- Debug.print_table( opts )
	

	local btn = display.newGroup()
	btn.anchorChildren = true 
	btn.anchorX = opts.anchorX
	btn.anchorY = opts.anchorY
	btn.x = opts.x
	btn.y = opts.y

	if opts.parent then
		opts.parent:insert( btn )
	end

	-- can position the label or defaults to button center
	opts.label_x = opts.label_x or opts.x
	opts.label_y = opts.label_y or opts.y


	if opts.label then
		btn.label = display.newText( btn, opts.label, opts.label_x, opts.label_y, opts.font, opts.font_size )
		btn.label.fill =  opts.color
	end

	opts.width = opts.width or btn.label.contentWidth + opts.font_size*2
	opts.height = opts.height or btn.label.contentHeight + opts.font_size*2


	-- can set radius ( 0 for square, max of 1/2 height for perfectly round )
	opts.outline_radius = opts.outline_radius or opts.height / 2


	-- outline color defaults to primary color
	opts.press_color = opts.press_color or opts.color
	opts.outline_color = opts.outline_color or opts.color
	opts.outline_press_color = opts.outline_press_color or opts.press_color
	

	if opts.outline >= 0 then
		btn.outline = display.newRoundedRect( btn, opts.x, opts.y, opts.width, opts.height, opts.outline_radius )
		
		btn.outline.stroke = {type="image", filename="assets/textures/brushes/blur_brush1x4.png"}
		btn.outline.strokeWidth = opts.outline

		-- this can't be stroke= to get antialiased border
		btn.outline:setStrokeColor( unpack(opts.outline_color ) )

		btn.outline.fill = opts.bg_color
	end

	btn.label:toFront()


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
		elseif event.phase == 'ended' then
			display.getCurrentStage():setFocus( nil )
			if btn.outline then
				btn.outline:setStrokeColor( unpack( opts.outline_color ) )
				btn.outline.fill = opts.bg_color
			end
			if btn.label then
				btn.label.fill = opts.color
			end
			opts.onPress()
		elseif event.phase == 'cancelled' then
			display.getCurrentStage():setFocus( nil )
			if btn.outline then
				btn.outline:setStrokeColor( unpack( opts.outline_color ) )
				btn.outline.fill = opts.bg_color
			end
			if btn.label then
				btn.label.fill = opts.color
			end

		end
		return true
	end
	btn:addEventListener( 'touch', btn )

	-- make sure to return te thing
	return btn
end

-- make sure to return the module table
return M