require("game")

menu = {}

function menu:enter()
    self.main_menu = {
        items = { "Start", "Exit" },
        actions = {
            function() state.enter(game) end,
            function() love.event.push("quit") end
        }
    }

    self:set_submenu(self.main_menu)

    -- Move the selected item with keys.
    function love.keypressed(key)
        if key == "w" or key == "up" then
            if self.pointer == 1 then
                self.pointer = self.item_count    -- If self.pointer is at first item, set it to the last item.
            else
                self.pointer = self.pointer - 1
            end
        end
        if key == "r" or key == "down" then
            if self.pointer == self.item_count then
                self.pointer = 1             -- If self.pointer is at last item, set it to the first item.
            else
                self.pointer = self.pointer + 1
            end
        end
        if key == "return" or key == "space" then
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