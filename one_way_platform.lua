local bump = require("libs/bump_lua/bump")

one_way_slide = function(world, col, x,y,w,h, goalX, goalY, filter)
    if col.normal.y == -1 and not col.overlaps then
        return bump.responses.slide(world, col, x,y,w,h, goalX, goalY, filter)
    else
        return bump.responses.cross(world, col, x,y,w,h, goalX, goalY, filter)
    end
end