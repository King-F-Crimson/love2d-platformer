explosion = {
    sprite = love.graphics.newImage("assets/Explosion.png"),
    max_length = 60,
    max_width = 64,
    properties = { is_explosion = true }
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
        self.origin = {}
        self.origin.x, self.origin.y, self.world = x, y, world
    end
    self.w, self.h = 1, 1
    self.x, self.y = self.origin.x - (self.w / 2), self.origin.y - (self.h / 2)
    self.scale = 1/64
end

function explosion:update(dt)
    if self.length > 0 then
        self.length = self.length - 1

        self.scale = (self.max_length - self.length) / self.max_length
        self.w = self.max_width * self.scale
        self.h = self.w
        self.x, self.y = self.origin.x - (self.w / 2), self.origin.y - (self.h / 2)

        self.bump_world:update(self, self.x, self.y, self.w, self.h)
    else
        self.world:delete_entity(self)
    end
end

function explosion:draw()
    love.graphics.draw(self.sprite, self.x, self.y, 0, self.scale, self.scale)
end