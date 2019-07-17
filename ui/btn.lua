
-- This module is a simple button creator
-- it uses rounded rectangle to create buttons from circles to rectangles
-- buttons can include a lable and/or an icon (icons require fontawesome module)
-- can someday extend to include an image or image-sheet

-- container
--   - outline
--   - fill
-- label
--   - fill
-- icon

-- use via: 
-- Btn = require( "ui.btn" )
-- my_btn = Btn:new({ my_args })

-- Here are all available args so far...

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
local device = require( 'utilities.device' )
local Debug = require( 'utilities.debug' )


-- Table to hold everything
local M = {}

-- Default args
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
function M:new( args )
	if args == nil then args = M.defaults end


	-- passing in a theme sets font and colors by default (args should over-ride)
	local theme = nil
	if args.theme_name then
		theme = require( 'ui.themes.' .. args.theme_name )
	elseif args.theme then
		theme = args.theme
	end


	if theme then
		args.font = args.font or theme.font

		args.outline = args.outline or theme.btn_outline

		args.color = args.color or theme.colors.font
		args.press_color = args.press_color or theme.colors.font_press

		args.bg_color = args.bg_color or theme.colors.btn_bg
		args.bg_press_color = args.bg_press_color or theme.colors.btn_bg_press

		args.outline_color = args.outline_color or theme.colors.btn_outline
		args.outline_press_color = args.outline_press_color or theme.colors.btn_outline_press
	end
	

	-- fill in any missing args from module defaults
	for key, value in pairs( M.defaults ) do
		args[key] = args[key] or M.defaults[key]
	end

	-- print( "btn args: " )
	-- Debug.print_table( args )
	

	local btn = display.newGroup()
	btn.anchorChildren = true 
	btn.anchorX = args.anchorX
	btn.anchorY = args.anchorY
	btn.x = args.x
	btn.y = args.y

	if args.parent then
		args.parent:insert( btn )
	end

	-- can position the label or defaults to button center
	args.label_x = args.label_x or args.x
	args.label_y = args.label_y or args.y


	if args.label then
		btn.label = display.newText( btn, args.label, args.label_x, args.label_y, args.font, args.font_size )
		btn.label.fill =  args.color
	end

	args.width = args.width or btn.label.contentWidth + args.font_size*2
	args.height = args.height or btn.label.contentHeight + args.font_size*2


	-- can set radius ( 0 for square, max of 1/2 height for perfectly round )
	args.outline_radius = args.outline_radius or args.height / 2


	-- outline color defaults to primary color
	args.press_color = args.press_color or args.color
	args.outline_color = args.outline_color or args.color
	args.outline_press_color = args.outline_press_color or args.press_color
	

	if args.outline >= 0 then
		btn.outline = display.newRoundedRect( btn, args.x, args.y, args.width, args.height, args.outline_radius )
		
		btn.outline.stroke = {type="image", filename="assets/textures/brushes/blur_brush1x4.png"}
		btn.outline.strokeWidth = args.outline

		-- this can't be stroke= to get antialiased border
		btn.outline:setStrokeColor( unpack(args.outline_color ) )

		btn.outline.fill = args.bg_color
	end

	btn.label:toFront()


	function btn:touch( event )

		if event.phase == 'began' then

			 display.getCurrentStage():setFocus( event.target )

			if btn.outline then
				btn.outline:setStrokeColor( unpack( args.outline_press_color ) )
				btn.outline.fill = args.bg_press_color
			end
			if btn.label then
				btn.label.fill = args.press_color
			end
		elseif event.phase == 'ended' then
			display.getCurrentStage():setFocus( nil )
			if btn.outline then
				btn.outline:setStrokeColor( unpack( args.outline_color ) )
				btn.outline.fill = args.bg_color
			end
			if btn.label then
				btn.label.fill = args.color
			end
			args.onPress()
		elseif event.phase == 'cancelled' then
			display.getCurrentStage():setFocus( nil )
			if btn.outline then
				btn.outline:setStrokeColor( unpack( args.outline_color ) )
				btn.outline.fill = args.bg_color
			end
			if btn.label then
				btn.label.fill = args.color
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