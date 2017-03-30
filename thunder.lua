require("entity")
local anim8 = require '../libs/anim8/anim8'

thunder = entity:new({
    h = 256,
    w = 64,
    properties = {
        is_thunder = true
    },

    image = love.graphics.newImage("assets/lightning.png")
})
thunder.image:setFilter("nearest")

function thunder:init()
    self.lifespan = 90

    self.sound = love.audio.newSource("assets/thunder.wav", "static")
    self.sound:play()

    local grid = anim8.newGrid(64, 256, self.image:getWidth(), self.image:getHeight())
    self.animation = anim8.newAnimation(grid('1-2', 1), 4)
end

function thunder:draw()
    self.animation:draw(self.image, self.x, self.y)
end

function thunder:update()
    self.animation:update(1)
    movement.update_spatial(self)

    if self.lifespan ~= 0 then
        self.lifespan = self.lifespan - 1
    else
        self.world:delete_entity(self)
    end
end

function thunder.filter()
    return 'cross'
end