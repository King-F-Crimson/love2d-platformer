require("movement")
require("animate")

local anim8 = require '../libs/anim8/anim8'

player = {
    x = 0,
    y = 0,
    velocity =     { x = 0, y = 0 },
    acceleration = { x = 0, y = 0 },
    max_speed =    { x = 6, y = 6 },
    state = standing,
    properties = { floating = false }
}

function player:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function player:init(spawn)
    self.stand_animation, self.stand_sprite = animate("assets/trump_stand.png", 24)
    self.walk_animation, self.walk_sprite = animate("assets/trump_walk.png", 12)
    self.jump_animation, self.jump_sprite = animate("assets/trump_jump.png", 12)
    self.fall_animation, self.fall_sprite = animate("assets/trump_fall.png", 12)
    self.x      = spawn.x
    self.y      = spawn.y
end

function player:update(dt)
    -- The animation does not use dt but frame count.
    self.stand_animation:update(1)
    self.walk_animation:update(1)

    local input = self:get_input()
    self:move(input)
end

function player:get_input()
    local input = { left = false, right = false, jump = false }
    input.left  = love.keyboard.isDown("left")  or love.keyboard.isDown("a")
    input.right = love.keyboard.isDown("right") or love.keyboard.isDown("s")
    input.jump  = love.keyboard.isDown("up")    or love.keyboard.isDown("space")

    return input
end

function player:move(input)
    self.state:move(self, input)
    movement.update_spatial(self)
end

function player:draw()
    local animation = nil
    local sprite = nil
    if self.state == standing then
        animation = self.stand_animation
        sprite = self.stand_sprite
    elseif self.state == walking then
        animation = self.walk_animation
        sprite = self.walk_sprite
    elseif self.state == jumping then
        animation = self.jump_animation
        sprite = self.jump_sprite
    elseif self.state == falling then
        animation = self.fall_animation
        sprite = self.fall_sprite
    end

    animation:draw(
        sprite,
        self.x,
        self.y
    )
end

function player:jump_pressed()
    if self.state == standing or self.state == walking then
        self.ready_jump = true
    end
end