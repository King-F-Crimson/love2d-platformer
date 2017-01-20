require("control")

standing = {}
walking  = {}
jumping  = {}
falling  = {}

function standing:move(entity)
    if love.keyboard.isDown(control.move_left) then
        entity.state = walking
    end
    if love.keyboard.isDown(control.move_right) then
        entity.state = walking
    end
    apply_friction(entity)
    if love.keyboard.isDown(control.jump) then
        entity.state = jumping
        jumping:enter(entity)
    end
end

function standing:enter(entity)
    entity.acceleration.x, entity.velocity.y = 0, 0
end

function walking:move(entity)
    horizontal_move(entity)
    if love.keyboard.isDown(control.jump) then
        entity.state = jumping
        jumping:enter(entity)
    end
end

function apply_friction(entity)
    entity.velocity.x = entity.velocity.x * 0.8
end

function jumping:move(entity)
    horizontal_move(entity)
    entity.acceleration.y = -1
    if self.jump_length ~= 0 then
        self.jump_length = self.jump_length - 1
    end
    -- Make the player fall when it reach max jump length, hits ceiling, or jump button is released.
    if self.jump_length == 0 or hits_ceiling(entity) or not love.keyboard.isDown(control.jump) then
        entity.state = falling
    end
end

function jumping:enter(entity)
    self.jump_length = 30
    entity.velocity.y = -2
end

function falling:move(entity)
    horizontal_move(entity)
    entity.acceleration.y = 1
    if is_grounded(entity) then
        entity.state = standing
        standing:enter(entity)
    end
end

function update_spatial(entity)
    -- Update velocity based on acceleration.
    entity.velocity.x, entity.velocity.y = entity.velocity.x + entity.acceleration.x, entity.velocity.y + entity.acceleration.y

    -- Cap speed.
    if entity.velocity.x > entity.max_speed.x then
        entity.velocity.x = entity.max_speed.x
    elseif entity.velocity.x < -entity.max_speed.x then
        entity.velocity.x = -entity.max_speed.x
    end
    if entity.velocity.y > entity.max_speed.y then
        entity.velocity.y = entity.max_speed.y
    elseif entity.velocity.y < -entity.max_speed.y then
        entity.velocity.y = -entity.max_speed.y
    end
    
    entity.x, entity.y = world:move(entity, entity.x + entity.velocity.x, entity.y + entity.velocity.y)
end

function horizontal_move(entity)
    entity.acceleration.x = 0
    if love.keyboard.isDown(control.move_left) then
        entity.acceleration.x = entity.acceleration.x - 1
    end
    if love.keyboard.isDown(control.move_right) then
        entity.acceleration.x = entity.acceleration.x + 1
    end
    apply_friction(entity)
end

function is_grounded(entity)
    local is_grounded = false

    -- Check collision for everything one pixel under the entity.
    x, y, cols, len = world:check(entity, entity.x, entity.y + 1)

    -- Check if the entity hits ground.
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

function hits_ceiling(entity)
    local hits_ceiling = false

    -- Check collision for everything one pixel above the entity.
    x, y, cols, len = world:check(entity, entity.x, entity.y - 1)

    -- Check if the entity hits ceiling.
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