local bump = require("libs/bump_lua/bump")

local function is_solid(x, y, facing_right)
    -- Function to check if a pixel is solid in a slope tile.
    -- If the slope is left diagonal then the x is supposedly 'flipped'.
    -- Works by checking the sum of x and y of the given pixel in the tile.

    -- Example:
    -- ...#
    -- ..##
    -- .###
    -- ####
    -- Note: '.' is not solid and '#' is solid.
    -- Coord 1, 3
    -- ...#
    -- ..##
    -- .###
    -- #T##
    -- 1 + 3 = 4, which is more than the max length in any axis.

    x = x % 16
    y = y % 16
    if not facing_right then
        x = 15 - x
    end

    return (x + y) >= 15
end

-- Implement a function to move the item y position into nearest possible position on the upside of the bottom.
-- Example:
-- ...#
-- ..##
-- .###
-- ##B#
-- Note: 'B' is bottom.
-- Into:
-- ..B#
-- ..##
-- .###
-- ####

local slide_up = function(world, col, x,y,w,h, goalX, goalY, filter) end

slope_right = function(world, col, x,y,w,h, goalX, goalY, filter)
    local bottom_right = { x = goalX + col.item.w, y = goalY + col.item.h }
    if is_solid(bottom_right.x, bottom_right.y, true) then
        return bump.responses.slide(world, col, x,y,w,h, goalX, goalY, filter)
    else
        return bump.responses.cross(world, col, x,y,w,h, goalX, goalY, filter)
    end
end

slope_left = function(world, col, x,y,w,h, goalX, goalY, filter)
    local bottom_left = { x = goalX, y = goalY + col.item.h }
    if is_solid(bottom_left.x, bottom_left.y, false) then
        return bump.responses.slide(world, col, x,y,w,h, goalX, goalY, filter)
    else
        return bump.responses.cross(world, col, x,y,w,h, goalX, goalY, filter)
    end
end