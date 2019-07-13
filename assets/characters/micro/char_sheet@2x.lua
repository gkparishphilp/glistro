--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:2ccbc2a3816ff46173424ff3447f7e29:995b65165d9e98cef6e774b4e6055b2a:c07e96c7319a96e2545dea9da53e8679$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- enemy_block
            x=2,
            y=2,
            width=218,
            height=218,

        },
        {
            -- enemy_floater
            x=224,
            y=2,
            width=142,
            height=142,

        },
        {
            -- enemy_follower
            x=224,
            y=148,
            width=142,
            height=142,

        },
        {
            -- food_block
            x=224,
            y=294,
            width=142,
            height=142,

        },
        {
            -- food_floater
            x=370,
            y=2,
            width=142,
            height=142,

        },
        {
            -- food_wanderer
            x=440,
            y=294,
            width=62,
            height=142,

            sourceX = 40,
            sourceY = 0,
            sourceWidth = 142,
            sourceHeight = 142
        },
        {
            -- hero
            x=370,
            y=294,
            width=66,
            height=142,

            sourceX = 38,
            sourceY = 0,
            sourceWidth = 142,
            sourceHeight = 142
        },
        {
            -- inert_block
            x=2,
            y=224,
            width=218,
            height=218,

        },
        {
            -- inert_floater
            x=370,
            y=148,
            width=142,
            height=142,

        },
        {
            -- inert_wanderer
            x=506,
            y=294,
            width=50,
            height=142,

            sourceX = 46,
            sourceY = 0,
            sourceWidth = 142,
            sourceHeight = 142
        },
    },

    sheetContentWidth = 558,
    sheetContentHeight = 444
}

SheetInfo.frameIndex =
{

    ["enemy_block"] = 1,
    ["enemy_floater"] = 2,
    ["enemy_follower"] = 3,
    ["food_block"] = 4,
    ["food_floater"] = 5,
    ["food_wanderer"] = 6,
    ["hero"] = 7,
    ["inert_block"] = 8,
    ["inert_floater"] = 9,
    ["inert_wanderer"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
