result = {}

function result:enter(args)
    self.time = args.time
    self.win = args.win

    function love.keypressed(key)
        state.enter(menu_state)
    end
end

function result:update()

end

function result:draw()
    love.graphics.scale(2)

    local result_text
    if self.win then
        result_text = "Stage Clear"
    else
        result_text = "Failure"
    end

    love.graphics.print(result_text, 20, 20)

    love.graphics.print("Time: " .. tostring(self.time), 20, 40)
end