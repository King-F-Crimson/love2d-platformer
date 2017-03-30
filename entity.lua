entity = {
    x = 0,
    y = 0,
    w = 0,
    h = 0,
    origin = { x = 0, y = 0 },

    velocity =     { x = 0, y = 0 },
    acceleration = { x = 0, y = 0 },
    max_speed =    { x = 6, y = 6 },
    properties = {},
    facing_right = true,
}

function entity:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function entity:draw()
    if self.facing_right then
        love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1, self.origin.x, self.origin.y)
    else
        love.graphics.draw(self.sprite, self.x + self.w, self.y, 0, -1, 1, self.origin.x, self.origin.y)
    end
end

function entity:update()

end

function entity:init()

end

function entity:update_animations(dt)
    -- The animation does not use dt but frame count.
    for k, animation in pairs(self.animation) do
        animation:update(1)
    end
end

function entity:on_collision(cols, len)

end

function entity:on_ladder()
    local on_ladder = false

    local x, y, cols, len = self.bump_world:check(self, self.x, self.y, self.filter)
    for i = 1, len do
        if cols[i].other.properties.ladder then
            on_ladder = true
        end
    end

    return on_ladder
end

function entity.filter(item, other)
    if other.properties.solid then
        return 'slide'
    elseif other.properties.one_way_platform then
        if love.keyboard.isDown("down") then
            return 'cross'
        else
            return 'one_way_slide'
        end
    else
        return 'cross'
    end
end