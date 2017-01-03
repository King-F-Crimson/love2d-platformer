require("states/game")

menu = {}

function menu.enter()
    items = { "Start", "Exit" }
    actions = {}
    pointer = 1
    item_count = table.getn(items)

    actions[1] = function() state.enter(game) end
    actions[2] = function() love.event.push("quit") end

    -- Move the selected item with keys.
    function love.keypressed(key)
        if key == "w" then
            if pointer == 1 then
                pointer = item_count    -- If pointer is at first item, set it to the last item.
            else
                pointer = pointer - 1
            end
        end
        if key == "r" then
            if pointer == item_count then
                pointer = 1             -- If pointer is at last item, set it to the first item.
            else
                pointer = pointer + 1
            end
        end
        if key == "return" then
            actions[pointer]()
        end
    end
end

function menu.update()

end

function menu.draw()
    love.graphics.scale(2)

    for i = 1, item_count do
        if i == pointer then
            love.graphics.print('-', 10, 20 + (i * 14))
        end
        love.graphics.print(items[i], 20, 20 + (i * 14))
    end
end