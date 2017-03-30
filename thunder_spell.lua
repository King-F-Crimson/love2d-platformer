require("thunder")

thunder_spell = {
}

function thunder_spell:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function thunder_spell:init()
    self.cooldown = 0
end

function thunder_spell:update(dt)
    if self.cooldown ~= 0 then
        self.cooldown = self.cooldown - 1
    end
end

function thunder_spell:cast()
    if self.cooldown == 0 then
        local world = self.wielder.world

        local thunder = thunder:new({x = self.wielder.x + 160 + self.wielder.w, y = self.wielder.y - 256 + 14})
        if not self.wielder.facing_right then
            thunder.x = self.wielder.x - 160 - 64
        end

        world:spawn_entity(thunder, world.entities_layer)
        self.cooldown = 300
    end
end