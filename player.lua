player = {}

function player:move(x, y)
    movement = {x = 0, y = 0}

    if love.keyboard.isDown("w") then
        movement.y = movement.y - 1
    end
    if love.keyboard.isDown("s") then
        movement.x = movement.x + 1
    end
    if love.keyboard.isDown("r") then
        movement.y = movement.y + 1
    end
    if love.keyboard.isDown("a") then
        movement.x = movement.x - 1
    end

    self.x, self.y = world:move(self, self.x + movement.x, self.y + movement.y)
end