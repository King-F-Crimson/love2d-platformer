local grounded = {}
local airborne = {}

player = {
    acceleration = 1,
    gravity = 1,
    max_speed = 5,
    x = 0,
    y = 0,
    velocity = { x = 0, y = 0 },
    state = grounded,
}

function grounded.move(player)
    -- local movement = {x = 0, y = 0}

    -- if love.keyboard.isDown("up") then
    --     movement.y = movement.y - 1
    -- end
    -- if love.keyboard.isDown("right") then
    --     movement.x = movement.x + 1
    -- end
    -- if love.keyboard.isDown("down") then
    --     movement.y = movement.y + 1
    -- end
    -- if love.keyboard.isDown("left") then
    --     movement.x = movement.x - 1
    -- end

    if love.keyboard.isDown("space") then
        grounded.jump(player)
    end

    player.x, player.y = world:move(player, player.x + player.velocity.x, player.y + player.velocity.y)
end

function grounded.jump(player)
    player.velocity.y = -4
    player.state = airborne
end

function airborne.move(player)
    player.velocity.y = player.velocity.y + 1

    player.x, player.y, cols, len = world:move(player, player.x + player.velocity.x, player.y + player.velocity.y)

    -- Check if the player hits ground.
    for i = 1, len do
        local other = cols[i].other
        local normal = cols[i].normal
        -- True if item hits solid object and collides from top.
        if other.properties.solid and normal.x == 0 and normal.y == -1 then
            player.velocity.y = 0
            player.state = grounded
            print("Landed successfully")
        end
    end
end

function airborne.is_hitting_ground(player)
    local y_result = world:check(player, player.x + 1)
end

function player:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function player:move()
    self.state.move(self)
end

function player:draw()
    love.graphics.draw(
        self.sprite,
        self.x,
        self.y
    )
end