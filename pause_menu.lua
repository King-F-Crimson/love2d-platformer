require("state")
require("menu")

pause_menu = menu:new({
    x = 140,
    y = 90,
})

function pause_menu:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function pause_menu:init(game)
    self.game = game

    self.main_menu = {
        items = { "Continue", "Map Menu", "Exit" },
        actions = {
            function() self.game.paused = false, self.game:set_control() end,
            function() state.enter(menu_state) end,
            function() love.event.push("quit") end,
        }
    }

    self:set_control()
    self:set_submenu(self.main_menu)
end

function pause_menu:draw()
    love.graphics.push()
    love.graphics.scale(2)

    local screen = { width = love.graphics.getWidth() / 2, height = love.graphics.getHeight() / 2 }
    local rect_w, rect_h = 96, 64    local scale = 2
    local screen = { width = love.graphics.getWidth() / scale, height = love.graphics.getHeight() / scale }

    love.graphics.setColor(48, 48, 48)
    love.graphics.rectangle("fill", (screen.width - rect_w) / 2, (screen.height - rect_h) / 2, rect_w, rect_h)
    love.graphics.setColor(255, 255, 255)

    love.graphics.pop()

    menu.draw(self)
end