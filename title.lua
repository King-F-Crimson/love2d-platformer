require("menu_state")
require("state")
require("utility")

title = {
    logo = love.graphics.newImage("assets/Trump-16_Logo.png"),
    brick = love.graphics.newImage("assets/Brick_Tile.png"),
}
title.logo:setFilter("nearest")
title.brick:setFilter("nearest")
title.brick:setWrap("repeat")

function title:enter()
    self.logo_pos = {}
    self.logo_pos.x, self.logo_pos.y = self:get_logo_position()

    self.background = love.graphics.newQuad(0, 0, love.graphics.getWidth(), love.graphics.getHeight(), self.brick:getDimensions())

    function love.keypressed(key)
        state.enter(menu_state)
    end
end

function title:update()

end

function title:get_logo_position()
    local scale = 2
    local screen = { w = love.graphics.getWidth(), h = love.graphics.getHeight() }
    local logo = { w = self.logo:getWidth(), h = self.logo:getHeight() }

    local x = center(logo.w, screen.w, scale), logo.w, screen.w

    return x, logo.h / 2
end

function title:draw()
    love.graphics.push()
    love.graphics.scale(2)

    love.graphics.draw(self.brick, self.background)
    love.graphics.draw(self.logo, self.logo_pos.x, self.logo_pos.y)
    love.graphics.printf("Press any button to start!", center(200, love.graphics.getWidth(), 2), 200, 200, "center")

    love.graphics.pop()
end