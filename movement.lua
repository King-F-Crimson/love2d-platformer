standing = {}
walking = {}
jumping = {}
falling = {}
movement = {}

-- Standing control
function standing:enter(entity)
    entity.velocity.x = 0
    entity.velocity.y = 0
    entity.acceleration.x = 0
    entity.acceleration.y = 0
    return self
end

function standing:move(entity, input)
    if input.left or input.right then
        entity.state = walking:enter(entity)
    end
    if input.jump then
        entity.state = jumping:enter(entity)
    end
end

-- Walking control
function walking:enter(entity)
    entity.velocity.y = 0
    entity.acceleration.y = 0
    return self
end

function walking:move(entity, input)
    if not input.left and not input.right then
        entity.state = standing:enter(entity)
    else
        movement.horizontal_move(entity, input)
        if input.jump then
            entity.state = jumping:enter(entity)
        elseif not movement.is_grounded(entity) then
            entity.state = falling:enter(entity)
        end
    end
end

-- Jumping control
function jumping:enter(entity)
    entity.velocity.y = -5
    self.jump_length = 20
    self.minimum_length = 15

    return self
end

function jumping:move(entity, input)
    movement.horizontal_move(entity, input)
    if ((input.jump or self.jump_length > self.minimum_length) and self.jump_length ~= 0)
    and not movement.hits_ceiling(entity) then
        self.jump_length = self.jump_length - 1
    else
        self.jump_length = 0
        entity.state = falling:enter(entity)
    end
end

-- Falling control
function falling:enter(entity)
    entity.acceleration.y = 0.5
    return self
end

function falling:move(entity, input)
    movement.horizontal_move(entity, input)
    if movement.is_grounded(entity) then
        if entity.velocity.x == 0 then
            entity.state = standing:enter(entity)
        else
            entity.state = walking:enter(entity)
        end
    end
end

-- Global movement functions
function movement.update_spatial(entity)
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

function movement.is_grounded(entity)
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

function movement.hits_ceiling(entity)
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

function movement.horizontal_move(entity, input)
    x_velocity = 0
    if input.left  then x_velocity = x_velocity - 3 end
    if input.right then x_velocity = x_velocity + 3 end
    entity.velocity.x = x_velocity
end

-- require("control")

-- standing = {}
-- walking  = {}
-- jumping  = {}
-- falling  = {}

-- function standing:move(entity)
--     if love.keyboard.isDown(control.move_left) then
--         entity.state = walking
--     end
--     if love.keyboard.isDown(control.move_right) then
--         entity.state = walking
--     end
--     apply_friction(entity)
--     if love.keyboard.isDown(control.jump) then
--         entity.state = jumping
--         jumping:enter(entity)
--     end
-- end

-- function standing:enter(entity)
--     entity.acceleration.x, entity.velocity.y = 0, 0
-- end

-- function walking:move(entity)
--     horizontal_move(entity)
--     if love.keyboard.isDown(control.jump) then
--         entity.state = jumping
--         jumping:enter(entity)
--     end
-- end

-- function apply_friction(entity)
--     entity.velocity.x = entity.velocity.x * 0.8
-- end

-- function jumping:move(entity)
--     horizontal_move(entity)
--     entity.acceleration.y = -1
--     if self.jump_length ~= 0 then
--         self.jump_length = self.jump_length - 1
--     end
--     -- Make the player fall when it reach max jump length, hits ceiling, or jump button is released.
--     if self.jump_length == 0 or hits_ceiling(entity) or not love.keyboard.isDown(control.jump) then
--         entity.state = falling
--     end
-- end

-- function jumping:enter(entity)
--     self.jump_length = 30
--     entity.velocity.y = -2
-- end

-- function falling:move(entity)
--     horizontal_move(entity)
--     entity.acceleration.y = 1
--     if is_grounded(entity) then
--         entity.state = standing
--         standing:enter(entity)
--     end
-- end

-- function update_spatial(entity)
--     -- Update velocity based on acceleration.
--     entity.velocity.x, entity.velocity.y = entity.velocity.x + entity.acceleration.x, entity.velocity.y + entity.acceleration.y

--     -- Cap speed.
--     if entity.velocity.x > entity.max_speed.x then
--         entity.velocity.x = entity.max_speed.x
--     elseif entity.velocity.x < -entity.max_speed.x then
--         entity.velocity.x = -entity.max_speed.x
--     end
--     if entity.velocity.y > entity.max_speed.y then
--         entity.velocity.y = entity.max_speed.y
--     elseif entity.velocity.y < -entity.max_speed.y then
--         entity.velocity.y = -entity.max_speed.y
--     end
    
--     entity.x, entity.y = world:move(entity, entity.x + entity.velocity.x, entity.y + entity.velocity.y)
-- end

-- function horizontal_move(entity)
--     entity.acceleration.x = 0
--     if love.keyboard.isDown(control.move_left) then
--         entity.acceleration.x = entity.acceleration.x - 1
--     end
--     if love.keyboard.isDown(control.move_right) then
--         entity.acceleration.x = entity.acceleration.x + 1
--     end
--     apply_friction(entity)
-- end

-- function is_grounded(entity)
--     local is_grounded = false

--     -- Check collision for everything one pixel under the entity.
--     x, y, cols, len = world:check(entity, entity.x, entity.y + 1)

--     -- Check if the entity hits ground.
--     for i = 1, len do
--         local other = cols[i].other
--         local normal = cols[i].normal
--         -- True if item hits solid object and collides from top.
--         if other.properties.solid and normal.x == 0 and normal.y == -1 then
--             is_grounded = true
--         end
--     end

--     return is_grounded
-- end

-- function hits_ceiling(entity)
--     local hits_ceiling = false

--     -- Check collision for everything one pixel above the entity.
--     x, y, cols, len = world:check(entity, entity.x, entity.y - 1)

--     -- Check if the entity hits ceiling.
--     for i = 1, len do
--         local other = cols[i].other
--         local normal = cols[i].normal
--         -- True if item hits solid object and collides from bottom.
--         if other.properties.solid and normal.x == 0 and normal.y == 1 then
--             hits_ceiling = true
--         end
--     end

--     return hits_ceiling
-- end