hud = {
    health_bar_pos = { x = 8, y = 8 },
    cash_pos = { x = 8, y = 24 },

    heart = love.graphics.newImage("assets/Heart.png"),
    heart_empty = love.graphics.newImage("assets/Heart_Empty.png"),
    cash = love.graphics.newImage("assets/Cash.png"),
}

hud.heart:setFilter("nearest")
hud.heart_empty:setFilter("nearest")
hud.cash:setFilter("nearest")

function hud:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function hud:init(world, player)
    self.world, self.player = world, player
end

function hud:draw()
    -- Restores the transform from world.
    love.graphics.push()
    love.graphics.scale(2)

    -- Draw hearts as many as the player's max health.
    for i = 1, self.player.max_health do
        local sprite
        local x = self.health_bar_pos.x + (i - 1) * 16
        local y = self.health_bar_pos.y
        if i <= self.player.health then
            sprite = self.heart
        else
            sprite = self.heart_empty
        end
        love.graphics.draw(sprite, x, y)
    end

    -- Draw cash icon and player's cash amount.
    love.graphics.draw(self.cash, self.cash_pos.x, self.cash_pos.y)
    love.graphics.print(self.player.cash, self.cash_pos.x + 24, self.cash_pos.y)

    love.graphics.pop()
end