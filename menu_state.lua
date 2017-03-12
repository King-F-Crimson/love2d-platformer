require("game")
require("menu")

menu_state = menu:new()

menu_state.brick = love.graphics.newImage("assets/Brick_Tile.png")
menu_state.brick:setFilter("nearest")
menu_state.brick:setWrap("repeat")

function menu_state:enter()
    self.main_menu = {
        items = { "Start", "Exit" },
        actions = {
            function() self:set_submenu(self.map_menu) end,
            function() love.event.push("quit") end
        }
    }

    -- If required, create code to automatically generate map menu.
    -- May require scrolling if there are too many maps.
    self.map_menu = {
        items = { "1-1", "1-2", "1-3", "1-4", "1-5", "1-6", "1-7", "1-8", "Return" },
        actions = {
            function() state.enter(game, "maps/map_1-1.lua") end,
            function() state.enter(game, "maps/map_1-2.lua") end,
            function() state.enter(game, "maps/map_1-3.lua") end,
            function() state.enter(game, "maps/map_1-4.lua") end,
            function() state.enter(game, "maps/map_1-5.lua") end,
            function() state.enter(game, "maps/map_1-6.lua") end,
            function() state.enter(game, "maps/map_1-7.lua") end,
            function() state.enter(game, "maps/map_1-8.lua") end,
            function() self:set_submenu(self.main_menu) end
        }
    }

    self.background = love.graphics.newQuad(0, 0, love.graphics.getWidth(), love.graphics.getHeight(), self.brick:getDimensions())

    self:set_control()
    self:set_submenu(self.main_menu)
    love.graphics.push()
end

function menu_state:draw()
    love.graphics.push()
    love.graphics.scale(2)

    love.graphics.draw(self.brick, self.background)

    love.graphics.pop()

    menu.draw(self)
end