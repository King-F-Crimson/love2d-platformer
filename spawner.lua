spawner = {}

function spawner:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function spawner:init(world, entity)
    self.world = world
    self.cooldown = 120

    self.entity = entity
    self.entity.x = self.x
    self.entity.y = self.y
end

function spawner:update(dt)
    if cooldown == 0 then
        if self:is_in_spawning_distance() then
            self:spawn()
            cooldown = 120
        end
    else
        cooldown = cooldown - 1
    end
end

function spawner:spawn()
    self.world:spawn_entity(entity)
end

-- Check if spawner in spawning distance that's far away from the player so entity
-- does not come out of nowhere.
-- Currently set to 80 unit in taxicab geometry.
function spawner:is_in_spawning_distance()
    local player = self.world.player
    local x = player.x - self.x
    local y = player.y - self.y
    return x > 80 or y > 80