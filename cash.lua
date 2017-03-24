require("entity")
require("movement")

cash = entity:new({
    sprite = love.graphics.newImage("assets/Cash.png"),
    sound = love.audio.newSource("assets/cash.wav", "static"),
})
cash.sprite:setFilter("nearest")

function cash:init()
    self.sound = love.audio.newSource("assets/cash.wav", "static")
end

function cash:on_collision(cols, len)
    for i = 1, len do
        if cols[i].other.properties.is_player then
            love.audio.play(self.sound)
            self.world:delete_entity(self)
        end
    end
end

function cash:update()
    movement.update_spatial(self)
end