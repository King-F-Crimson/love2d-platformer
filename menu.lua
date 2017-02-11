require("game")

menu = {
    scroll_sound = love.audio.newSource("assets/menu_scroll.wav", "static"),
    select_sound = love.audio.newSource("assets/menu_select.wav", "static")
}

function menu:enter()
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
        items = { "1-1", "1-2", "1-3", "Return" },
        actions = {
            function() state.enter(game, "maps/map_1-1.lua") end,
            function() state.enter(game, "maps/map_1-2.lua") end,
            function() state.enter(game, "maps/map_1-3.lua") end,
            function() self:set_submenu(self.main_menu) end
        }
    }

    self:set_submenu(self.main_menu)

    -- Move the selected item with keys.
    function love.keypressed(key)
        if key == "w" or key == "up" then
            self.scroll_sound:play()
            if self.pointer == 1 then
                self.pointer = self.item_count    -- If self.pointer is at first item, set it to the last item.
            else
                self.pointer = self.pointer - 1
            end
        end
        if key == "r" or key == "down" then
            self.scroll_sound:play()
            if self.pointer == self.item_count then
                self.pointer = 1             -- If self.pointer is at last item, set it to the first item.
            else
                self.pointer = self.pointer + 1
            end
        end
        if key == "return" or key == "space" then
            self.select_sound:play()
            self.actions[self.pointer]()
        end
    end
end

function menu:set_submenu(submenu)
    self.items = submenu.items
    self.actions = submenu.actions
    self.pointer = 1
    self.item_count = #submenu.items
end

function menu:update()

end

function menu:draw()
    love.graphics.scale(2)

    for i = 1, self.item_count do
        if i == self.pointer then
            love.graphics.print('-', 10, 20 + (i * 14))
        end
        love.graphics.print(self.items[i], 20, 20 + (i * 14))
    end
end