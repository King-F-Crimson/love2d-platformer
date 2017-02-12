result = {}

function result:enter(args)
    self.time = args.time

    function love.keypressed(key)
        state.enter(menu)
    end
end

function result:update()

end

function result:draw()
    love.graphics.scale(2)

    love.graphics.print("Time: " .. tostring(self.time), 20, 20)
end