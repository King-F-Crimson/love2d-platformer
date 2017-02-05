require("movement")
require("animate")
require("entity")
require("grenade_launcher")

local anim8 = require '../libs/anim8/anim8'

player = entity:new({
    max_speed =    { x = 6, y = 6 },
    state = standing,
    properties = {is_player = true},
    invincibility_timer = 0,
})

function player:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function player:init(spawn)
    self.animation[standing], self.sprite[standing] = animate("assets/trump_stand.png", 24)
    self.animation[walking],  self.sprite[walking]  = animate("assets/trump_walk.png", 12)
    self.animation[jumping],  self.sprite[jumping]  = animate("assets/trump_jump.png", 12)
    self.animation[falling],  self.sprite[falling]  = animate("assets/trump_fall.png", 12)
    self.x      = spawn.x
    self.y      = spawn.y
    self.velocity = { x = 0, y = 0 }
    self.acceleration = { x = 0, y = 0 }

    self.gun = grenade_launcher:new()
    self.gun:init()
    self.gun.wielder = self
end

function player:get_control()
    local control = { left = false, right = false, jump = false, fire = false }
    control.left  = love.keyboard.isDown("left")  or love.keyboard.isDown("a")
    control.right = love.keyboard.isDown("right") or love.keyboard.isDown("s")
    control.jump  = love.keyboard.isDown("up")    or love.keyboard.isDown("space") or love.keyboard.isDown("z")
    control.fire  = love.keyboard.isDown("x")

    return control
end

function player:draw()
    local animation = self.animation[self.state]
    local sprite = self.sprite[self.state]

    -- Blinks for four frames when invincible.
    if self.invincibility_timer % 8 < 4 then
        if self.facing_right then
            animation:draw(sprite, self.x - 4, self.y - 2, 0, 1, 1)
            self.gun:draw()
        else
            animation:draw(sprite, self.x + 12, self.y - 2, 0, -1, 1)
            self.gun:draw()
        end
    end
end

function player:jump_pressed()
    if self.state == standing or self.state == walking then
        self.ready_jump = true
    end
end

function player:update(dt)
    entity.update_animations(self, dt)

    if self.invincibility_timer > 0 then
        self.invincibility_timer = self.invincibility_timer - 1
    end

    local control = self:get_control()
    self:move(control)

    self.gun:update(dt)

    if control.fire and self.gun ~= nil then
        self.gun:fire()
    end
end

function player:move(control)
    self.state.move(self, control)
    movement.update_spatial(self)
end

function player:on_collision(cols, len)
    for i = 1, len do
        if cols[i].other.properties.is_enemy and self.invincibility_timer == 0 then
            self:get_hurt()
        end
    end
end

function player:get_hurt()
    self.invincibility_timer = 60
end