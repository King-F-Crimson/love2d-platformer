entity = {
    x = 0,
    y = 0,
    w = 0,
    h = 0,
    velocity =     { x = 0, y = 0 },
    acceleration = { x = 0, y = 0 },
    max_speed =    { x = 6, y = 6 },
    properties = {},
    facing_right = true,
    animation = {},
    sprite = {},
}

function entity:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function entity:draw()
	if facing_right then
		love.graphics.draw(self.sprite, self.x, self.y)
	else
		love.graphics.draw(self.sprite, self.x + 16, self.y, 0, -1, 1)
	end
end

function entity:update_animations(dt)
	-- The animation does not use dt but frame count.
    for k, animation in pairs(self.animation) do
        animation:update(1)
    end
end