

exit_door = {}

function exit_door:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function exit_door:init(door_spawn)
    self.x, self.y = door_spawn.x, door_spawn.y
    self.sprite = love.graphics.newImage("assets/Exit_Door.png")
    self.sprite:setFilter("nearest")
end

function exit_door:update()

end

function exit_door:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end