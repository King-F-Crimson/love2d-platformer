require("movement")

player = {
    acceleration = 1,
    gravity = 1,
    max_speed = 5,
    x = 0,
    y = 0,
    velocity = { x = 0, y = 0 },
    state = airborne,
}

function player:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function player:move()
    self.state.move(self)
end

function player:draw()
    local sprite = nil
    if self.state == grounded then
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