require("chili_monster")

require("utility")

spawner = {}

function spawner:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function spawner:init()
    self.cooldown = 120
    self.spawned = 0
    self.max_spawn = self.properties.max_spawn
end

function spawner:update(dt)
    if self.cooldown == 0 then
        if self:is_in_spawning_distance() and self.spawned < self.max_spawn then
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
    self.world:spawn_entity(self.entity:new{x = self.x, y = self.y,
        facing_right = self.properties.facing_right, spawner = self},
        self.world.entities_layer)
    self.spawned = self.spawned + 1
end

-- Check if spawner in spawning distance that's far away from the player so entity
-- does not come out of nowhere.
-- Currently set to in either axis.
function spawner:is_in_spawning_distance()
    local x, y = self.world:check_distance(self, self.world.player)
    return (x > 288 or y > 208)
end

function spawner:draw()

end

chili_spawner = spawner:new({entity = chili_monster})