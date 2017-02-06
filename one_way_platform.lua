local bump = require("libs/bump_lua/bump")

one_way_slide = function(world, col, x,y,w,h, goalX, goalY, filter)
    if col.normal.y == -1 and not col.overlaps then
        col.touched = true
        return bump.responses.slide(world, col, x,y,w,h, goalX, goalY, filter)
    else
        return bump.responses.cross(world, col, x,y,w,h, goalX, goalY, filter)
    end
end

one_way_bounce = function(world, col, x,y,w,h, goalX, goalY, filter)
    if col.normal.y == -1 and not col.overlaps then
        col.touched = true
        return bump.responses.bounce(world, col, x,y,w,h, goalX, goalY, filter)
    else
        return bump.responses.cross(world, col, x,y,w,h, goalX, goalY, filter)
    end
end