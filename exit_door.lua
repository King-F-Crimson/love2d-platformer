require("state")
require("result")

exit_door = {
    properties = {}
}

function exit_door:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function exit_door:init()
    self.sprite = love.graphics.newImage("assets/Exit_Door.png")
    self.sprite:setFilter("nearest")
end

function exit_door:update()
    self:check_player_exit()
end

function exit_door:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

function exit_door:check_player_exit()
    local x, y, cols, len = self.bump_world:check(self, self.x, self.y)

    for i = 1, len do
        if cols[i].other.properties.is_player then
            if love.keyboard.isDown("up") then
                self.world.game:finish()
            end
        end
    end
end