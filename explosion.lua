explosion = {
    sprite = love.graphics.newImage("assets/Explosion.png"),
    max_length = 60,
    properties = {}
}
explosion.sprite:setFilter("nearest")

function explosion:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function explosion:init(x, y, world)
    self.length = self.max_length
    -- Check to prevent init from world setting it to nil.
    if x ~= nil and y ~= nil and world ~= nil then
        self.x, self.y, self.world = x, y, world
    end
    self.w, self.h = 1, 1
end

function explosion:update(dt)
    if self.length > 0 then
        self.length = self.length - 1
    else
        self.world:delete_entity(self)
    end
end

function explosion:draw()
    local scale = (self.max_length - self.length) / self.max_length
    local offset = self.sprite:getHeight() * scale
    love.graphics.draw(self.sprite, self.x, self.y, 0, scale, scale, offset, offset)
end