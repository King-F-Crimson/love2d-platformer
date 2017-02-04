require("movement")
require("utility")

grenade = {
    w = 4,
    h = 4,
    properties = {},
    sprite = love.graphics.newImage("assets/Grenade.png"),
    max_speed = { x = 6, y = 6 }
}

grenade.sprite:setFilter("nearest")

function grenade:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function grenade:init(x, y, world, facing_right)
    self.fuse = 120
    if x ~= nil and y ~= nil and world ~= nil then
        self.x, self.y, self.world, self.facing_right = x, y, world, facing_right
        self.bump_world = world.bump_world
    end

    self.velocity = { x = 6, y = -2 }
    self.acceleration = { x = 0, y = 4/60 }

    if not self.facing_right then
        self.velocity.x = self.velocity.x * -1
    end
end

function grenade:update(dt)
    self:move()
    self:apply_friction()
end

function grenade:move()
    movement.update_spatial(self)
end

function grenade:apply_friction()
    -- Will result in 70% speed reduction after one second.
    local friction = 0.3 ^ (1/60)
    self.velocity.x, self.velocity.y = self.velocity.x * friction, self.velocity.y * friction
end

function grenade:on_collision(cols, len)
    for i = 1, len do
        if cols[i].other.properties.solid then
            if cols[i].normal.x ~= 0 then
                self.velocity.x = math.sign(cols[i].normal.x) * math.abs(self.velocity.x)
            end
            if cols[i].normal.y ~= 0 then
                self.velocity.y = math.sign(cols[i].normal.y) * math.abs(self.velocity.y)
            end
        end
    end
end

function grenade.filter(item, other)
    if other.properties.solid then
        return 'bounce'
    else
        return 'cross'
    end
end

function grenade:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end