require("game")
require("menu")

menu_state = menu:new()

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
        items = { "1-1", "1-2", "1-3", "1-4", "Return" },
        actions = {
            function() state.enter(game, "maps/map_1-1.lua") end,
            function() state.enter(game, "maps/map_1-2.lua") end,
            function() state.enter(game, "maps/map_1-3.lua") end,
            function() state.enter(game, "maps/map_1-4.lua") end,
            function() self:set_submenu(self.main_menu) end
        }
    }

    self:set_control()
    self:set_submenu(self.main_menu)
    love.graphics.push()
end