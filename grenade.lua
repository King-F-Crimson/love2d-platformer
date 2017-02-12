require("movement")
require("utility")
require("explosion")

grenade = {
    w = 4,
    h = 4,
    properties = {},
    sprite = love.graphics.newImage("assets/Grenade.png"),
    explosion_sound = love.audio.newSource("assets/explosion_1.wav", "static"),
    max_speed = { x = 6, y = 6 }
}

grenade.sprite:setFilter("nearest")

function grenade:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function grenade:init(x, y, facing_right, world)
    self.fuse = 120
    -- Check to prevent init from world setting it to nil.
    if x ~= nil and y ~= nil and facing_right ~= nil and world ~= nil then
        self.x, self.y, self.facing_right, self.world = x, y, facing_right, world
    end

    self.velocity = { x = 4, y = -2 }
    self.acceleration = { x = 0, y = 4/60 }

    if not self.facing_right then
        self.velocity.x = self.velocity.x * -1
    end
end

function grenade:update(dt)
    self:move()
    self:apply_friction()

    if self.fuse > 0 and not self.explode_flag then
        self.fuse = self.fuse - 1
    else
        self:explode()
    end
end

function grenade:move()
    movement.update_spatial(self)
end

function grenade:apply_friction()
    -- Speed will be 0.8 times of its original after one second (60 frames).
    local friction = 0.8 ^ (1/60)
    self.velocity.x, self.velocity.y = self.velocity.x * friction, self.velocity.y * friction
end

function grenade:on_collision(cols, len)
    for i = 1, len do
        if cols[i].other.properties.solid or cols[i].touched then
            -- Collision mirrors the velocity and reduce it.
            if cols[i].normal.x ~= 0 then
                self.velocity.x = math.sign(cols[i].normal.x) * math.abs(self.velocity.x) * 0.6
            end
            if cols[i].normal.y ~= 0 then
                self.velocity.y = math.sign(cols[i].normal.y) * math.abs(self.velocity.y) * 0.6
            end
        elseif cols[i].other.properties.is_enemy then
            self.explode_flag = true
        end
    end
end

function grenade:explode()
    -- Create new explosion on its location.
    local explosion = explosion:new()
    explosion:init(self.x, self.y, self.world)
    self.world:spawn_entity(explosion, self.world.entities_layer)

    -- Play explosion sound.
    self.explosion_sound:play()

    -- Delete self from bump world and the game.
    self.world:delete_entity(self)
end

function grenade.filter(item, other)
    if other.properties.solid then
        return 'bounce'
    elseif other.properties.one_way_platform then
        return 'one_way_bounce'
    else
        return 'cross'
    end
end

function grenade:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end