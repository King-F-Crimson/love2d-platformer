entity = {
    x = 0,
    y = 0,
    w = 0,
    h = 0,
    velocity =     { x = 0, y = 0 },
    acceleration = { x = 0, y = 0 },
    max_speed =    { x = 0, y = 0 },
    properties = {},
    facing_right = true,
    states = {},
    animation = {},
    sprite = {}
}

function entity:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function entity:draw()
	if facing_rigth then
		love.graphics.draw(self.sprite, self.x, self.y)
	else
		love.graphics.draw(self.sprite, self.x + 16, self.y, 0, -1, 1)
	end
end

function entity:move(control)
    self.state:move(self, control)
    movement.update_spatial(self)
end

function entity:update(dt)
	-- The animation does not use dt but frame count.
    for k, animation in pairs(self.animation) do
        animation:update(1)
    end

    local control = self:get_control()
    self:move(control)
end