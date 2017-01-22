require("movement")

player = {
    x = 0,
    y = 0,
    velocity =     { x = 0, y = 0 },
    acceleration = { x = 0, y = 0 },
    max_speed =    { x = 6, y = 6 },
    state = standing,
    properties = { floating = false }
}

function player:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function player:update()
    local input = self:get_input()
    self:move(input)
end

function player:get_input()
    local input = { left = false, right = false, jump = false }
    input.left  = love.keyboard.isDown("left")  or love.keyboard.isDown("a")
    input.right = love.keyboard.isDown("right") or love.keyboard.isDown("s")
    input.jump  = love.keyboard.isDown("up")    or love.keyboard.isDown("space")

    return input
end

function player:move(input)
    self.state:move(self, input)
    movement.update_spatial(self)
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