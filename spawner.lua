require("chili_monster")

spawner = {}

function spawner:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function spawner:init()
    self.cooldown = 120
end

function spawner:update(dt)
    if self.cooldown == 0 then
        if self:is_in_spawning_distance() then
            self:spawn()
            self.cooldown = 120
        end
    else
        self.cooldown = self.cooldown - 1
    end
end

function spawner:spawn()
    -- Temporary workaround, to make player damaged by spawner.
    -- Once fixed spawner object on the map can have is_enemy property again.
    local properties = self.properties
    properties.is_enemy = true

    self.world:spawn_entity(self.entity:new{x = self.x, y = self.y, properties = self.properties},
        self.world.entities_layer)
end

-- Check if spawner in spawning distance that's far away from the player so entity
-- does not come out of nowhere.
-- Currently set to in either axis.
function spawner:is_in_spawning_distance()
    local player = self.world.player
    local x = player.x - self.x
    local y = player.y - self.y
    return x > 80 or y > 80
end

function spawner:draw()

end

chili_spawner = spawner:new({entity = chili_monster})