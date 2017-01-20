require("movement")

player = {
    x = 0,
    y = 0,
    velocity =     { x = 0, y = 0 },
    acceleration = { x = 0, y = 0 },
    max_speed =    { x = 4, y = 4 },
    state = standing,
    properties = { floating = false }
}

function player:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function player:move()
    self.state:move(self)
    update_spatial(self)
end

function player:draw()
    local sprite = nil
    if self.state == standing or self.state == walking then
        sprite = self.sprite
    else
        sprite = self.air_sprite
    end

    love.graphics.draw(
        sprite,
        self.x,
        self.y
    )
end