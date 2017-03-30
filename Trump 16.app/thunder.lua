require("entity")

thunder = entity:new({
    image = love.graphics.newImage("assets/lightning.png")
})

function thunder:init()
    self.lifespan = 90

    local grid = anim8.newGrid(64, 256, self.image:getWidth(), self.image:getHeight())
    self.animation = anim8.newAnimation(grid('1-2', 1), 4)
end

function thunder:draw()
    self.animation:draw(sprite, self.x, self.y)
end

function thunder:update()
    if self.lifespan ~= 0 then
        self.lifespan = self.lifespan - 1
    else
        self.world:delete_entity(self)
    end

    self.animation:update(1)
end