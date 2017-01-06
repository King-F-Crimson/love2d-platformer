local grounded = {}
local airborne = {}

player = {
    acceleration = 1,
    gravity = 1,
    max_speed = 5,
    x = 0,
    y = 0,
    velocity = { x = 0, y = 0 },
    state = airborne,
}

function grounded.move(player)
    if love.keyboard.isDown("space") then
        grounded.jump(player)
    end
    player.velocity.x = 0
    if love.keyboard.isDown("left") then
        player.velocity.x = -2
    end
    if love.keyboard.isDown("right") then
        player.velocity.x = 2
    end

    player.x, player.y = world:move(player, player.x + player.velocity.x, player.y + player.velocity.y)

    if not player:is_grounded() then
        player.state = airborne
    end
end

function grounded.jump(player)
    player.velocity.y = -10
    player.state = airborne
end

function airborne.move(player)
    player.velocity.y = player.velocity.y + 0.4

    player.x, player.y, cols, len = world:move(player, player.x + player.velocity.x, player.y + player.velocity.y)

    if player:is_grounded() then
        player.velocity.y = 0
        player.state = grounded
    end
    if player:hits_ceiling() then
        player.velocity.y = 0
    end
end

function player:is_grounded()
    is_grounded = false

    -- Check collision for everything one pixel under the player.
    x, y, cols, len = world:check(self, self.x, self.y + 1)

    -- Check if the player hits ground.
    for i = 1, len do
        local other = cols[i].other
        local normal = cols[i].normal
        -- True if item hits solid object and collides from top.
        if other.properties.solid and normal.x == 0 and normal.y == -1 then
            is_grounded = true
        end
    end

    return is_grounded
end

function player:hits_ceiling()
    hits_ceiling = false

    -- Check collision for everything one pixel above the player.
    x, y, cols, len = world:check(self, self.x, self.y - 1)

    -- Check if the player hits ceiling.
    for i = 1, len do
        local other = cols[i].other
        local normal = cols[i].normal
        -- True if item hits solid object and collides from bottom.
        if other.properties.solid and normal.x == 0 and normal.y == 1 then
            hits_ceiling = true
        end
    end

    return hits_ceiling
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
    local sprite = nil
    if self.state == grounded then
        sprite = self.sprite
    else
        sprite = self.air_sprite
    end

    love.graphics.draw(
        sprite,
        self.x,
        self.y
    )
end