player = {}

function player:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function player:move()
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

    self.x, self.y = self.world:move(self, self.x + movement.x, self.y + movement.y)
end

function player:draw()
    love.graphics.draw(
        self.sprite,
        self.x,
        self.y
    )
end