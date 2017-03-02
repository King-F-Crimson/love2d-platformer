require("menu_state")
require("state")

title = {
    logo = love.graphics.newImage("assets/Trump-16_Logo.png")
}
title.logo:setFilter("nearest")

function title:enter()
    self.logo_pos = {}
    self.logo_pos.x, self.logo_pos.y = self:get_logo_position()

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
    local x = (screen.w / 2 - logo.w) / scale

    print(x, logo.w, screen.w)

    return x, logo.h
end

function title:draw()
    love.graphics.push()
    love.graphics.scale(2)

    love.graphics.draw(self.logo, self.logo_pos.x, self.logo_pos.y)

    love.graphics.pop()
end