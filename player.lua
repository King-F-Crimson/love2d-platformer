require("movement")
require("animate")
require("entity")

local anim8 = require '../libs/anim8/anim8'

player = entity:new({
    max_speed =    { x = 6, y = 6 },
    state = standing,
})

function player:init(spawn)
    self.animation[standing], self.sprite[standing] = animate("assets/trump_stand.png", 24)
    self.animation[walking],  self.sprite[walking]  = animate("assets/trump_walk.png", 12)
    self.animation[jumping],  self.sprite[jumping]  = animate("assets/trump_jump.png", 12)
    self.animation[falling],  self.sprite[falling]  = animate("assets/trump_fall.png", 12)
    self.x      = spawn.x
    self.y      = spawn.y
end

function player:get_control()
    local control = { left = false, right = false, jump = false }
    control.left  = love.keyboard.isDown("left")  or love.keyboard.isDown("a")
    control.right = love.keyboard.isDown("right") or love.keyboard.isDown("s")
    control.jump  = love.keyboard.isDown("up")    or love.keyboard.isDown("space")

    return control
end

function player:draw()
    local animation = self.animation[self.state]
    local sprite = self.sprite[self.state]

    if self.facing_right then
        animation:draw(sprite, self.x, self.y, 0, 1, 1)
    else
        animation:draw(sprite, self.x + 16, self.y, 0, -1, 1)
    end
end

function player:jump_pressed()
    if self.state == standing or self.state == walking then
        self.ready_jump = true
    end
end

function player:update(dt)
    self:update_animations(dt)

    local control = self:get_control()
    self:move(control)
end

function player:move(control)
    self.state.move(self, control)
    movement.update_spatial(self)
end