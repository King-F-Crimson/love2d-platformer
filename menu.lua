menu = {
    x = 10,
    y = 20,
    y_spacing = 14,
    scroll_sound = love.audio.newSource("assets/menu_scroll.wav", "static"),
    select_sound = love.audio.newSource("assets/menu_select.wav", "static"),
}

function menu:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function menu:set_control()
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
            love.graphics.print('-', self.x , self.y + (i * self.y_spacing))
        end
        love.graphics.print(self.items[i], self.x + 10 , self.y  + (i * self.y_spacing))
    end
end