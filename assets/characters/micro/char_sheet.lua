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
            x=1,
            y=1,
            width=109,
            height=109,

        },
        {
            -- enemy_floater
            x=112,
            y=1,
            width=71,
            height=71,

        },
        {
            -- enemy_follower
            x=112,
            y=74,
            width=71,
            height=71,

        },
        {
            -- food_block
            x=112,
            y=147,
            width=71,
            height=71,

        },
        {
            -- food_floater
            x=185,
            y=1,
            width=71,
            height=71,

        },
        {
            -- food_wanderer
            x=220,
            y=147,
            width=31,
            height=71,

            sourceX = 20,
            sourceY = 0,
            sourceWidth = 71,
            sourceHeight = 71
        },
        {
            -- hero
            x=185,
            y=147,
            width=33,
            height=71,

            sourceX = 19,
            sourceY = 0,
            sourceWidth = 71,
            sourceHeight = 71
        },
        {
            -- inert_block
            x=1,
            y=112,
            width=109,
            height=109,

        },
        {
            -- inert_floater
            x=185,
            y=74,
            width=71,
            height=71,

        },
        {
            -- inert_wanderer
            x=253,
            y=147,
            width=25,
            height=71,

            sourceX = 23,
            sourceY = 0,
            sourceWidth = 71,
            sourceHeight = 71
        },
    },

    sheetContentWidth = 279,
    sheetContentHeight = 222
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
