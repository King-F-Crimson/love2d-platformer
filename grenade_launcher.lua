require("grenade")

grenade_launcher = {
    sprite = love.graphics.newImage("assets/Grenade_Launcher.png"),
    fire_sound = love.audio.newSource("assets/grenade_fire.wav", "static")
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
        local world = self.wielder.world

        local x, y, facing_right = wielder:get_gun_position()
        if facing_right then
            x = x + 8
        else
            x = x - 12
        end
        grenade:init(x, y, facing_right, world)
        self.fire_sound:play()

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