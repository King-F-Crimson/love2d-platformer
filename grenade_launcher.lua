require("grenade")

grenade_launcher = {
    sprite = love.graphics.newImage("assets/Grenade_Launcher.png")
}
grenade_launcher.sprite:setFilter("nearest")

function grenade_launcher:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function grenade_launcher:init()
    self.cooldown = 0
end

function grenade_launcher:fire()
    if self.cooldown == 0 then
        local grenade = grenade:new()
        local wielder = self.wielder
        grenade:init(wielder.x, wielder.y, wielder.world, wielder.facing_right)
        local world = self.wielder.world
        world:spawn_entity(grenade, world.entities_layer)
        self.cooldown = 60
    end
end

function grenade_launcher:update(dt)
    if self.cooldown > 0 then
        self.cooldown = self.cooldown - 1
    end
end

function grenade_launcher:draw(x, y, facing_right)
    if facing_right then
        love.graphics.draw(self.sprite, x, y)
    else
        love.graphics.draw(self.sprite, x, y, 0, -1, 1)
    end
end