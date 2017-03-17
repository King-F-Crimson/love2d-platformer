standing = { name = "standing" }
walking  = { name = "walking"  }
jumping  = { name = "jumping", jump_sound = love.audio.newSource("assets/jump_1.wav", "static") }
falling  = { name = "falling"  }
climbing = { name = "climbing" }
movement = {}

-- Standing control
function standing.enter(entity)
    entity.velocity.x = 0
    entity.velocity.y = 0
    entity.acceleration.x = 0
    entity.acceleration.y = 0
    return standing
end

function standing.move(entity, input)
    if input.left or input.right then
        entity.state = walking.enter(entity)
    end
    if input.up and entity:on_ladder() then
        entity.state = climbing.enter(entity)
    end
    if entity.ready_jump then
        entity.ready_jump = false
        entity.state = jumping.enter(entity)
    elseif not movement.is_grounded(entity) then
        entity.state = falling.enter(entity)
    end
end

-- Walking control
function walking.enter(entity)
    entity.velocity.y = 0
    entity.acceleration.y = 0
    return walking
end

function walking.move(entity, input)
    if input.up and entity:on_ladder() then
        entity.state = climbing.enter(entity)
    end
    if not input.left and not input.right then
        entity.state = standing.enter(entity)
    else
        movement.horizontal_move(entity, input)
        if entity.ready_jump then
            entity.ready_jump = false
            entity.state = jumping.enter(entity)
        elseif not movement.is_grounded(entity) then
            entity.state = falling.enter(entity)
        end
    end
end

-- Jumping control
function jumping.enter(entity)
    entity.velocity.y = -5
    entity.jump_length = 15
    entity.minimum_length = 10

    jumping.jump_sound:play()

    return jumping
end

function jumping.move(entity, input)
    movement.horizontal_move(entity, input)
    if not movement.hits_ceiling(entity) then
        if ((input.jump or entity.jump_length > entity.minimum_length) and entity.jump_length ~= 0) then
            entity.jump_length = entity.jump_length - 1
        else
            entity.state = falling.enter(entity)
        end
    else
        entity.velocity.y = 0
        entity.state = falling.enter(entity)
    end
    if input.up and entity:on_ladder() then
        entity.state = climbing.enter(entity)
    end
end

-- Falling control
function falling.enter(entity)
    entity.acceleration.y = 0.8
    return falling
end

function falling.move(entity, input)
    movement.horizontal_move(entity, input)
    if movement.is_grounded(entity) then
        if entity.velocity.x == 0 then
            entity.state = standing.enter(entity)
        else
            entity.state = walking.enter(entity)
        end
    end
    if input.up and entity:on_ladder() then
        entity.state = climbing.enter(entity)
    end
end

function climbing.enter(entity)
    entity.acceleration.x = 0
    entity.acceleration.y = 0
    entity.velocity.x = 0
    entity.velocity.y = 0
    return climbing
end

function climbing.move(entity, input)
    entity.velocity.x, entity.velocity.y = 0, 0
    if input.right then
        entity.velocity.x = entity.velocity.x + 2
    end
    if input.left then
        entity.velocity.x = entity.velocity.x - 2
    end
    if input.down then
        entity.velocity.y = entity.velocity.y + 2
    end
    if input.up then
        entity.velocity.y = entity.velocity.y - 2
    end

    if entity.velocity.x > 0 then
        entity.facing_right = true
    elseif entity.velocity.x < 0 then
        entity.facing_right = false
    end

    if not entity:on_ladder() then
        entity.state = falling.enter(entity)
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
    
    local cols, len
    entity.x, entity.y, cols, len = entity.bump_world:move(entity, entity.x + entity.velocity.x, entity.y + entity.velocity.y, entity.filter)
    entity:on_collision(cols, len)
end

function movement.is_grounded(entity)
    local is_grounded = false

    -- Check collision for everything one pixel under the entity.
    local x, y, cols, len = entity.bump_world:check(entity, entity.x, entity.y + 1, entity.filter)

    -- Check if the entity hits ground.
    for i = 1, len do
        local other = cols[i].other
        local normal = cols[i].normal
        local touch = cols[i].touch
        -- True if item hits solid or one way platform object and collides from top.
        if (other.properties.solid or other.properties.one_way_platform) and normal.x == 0 and normal.y == -1 and touch.y == entity.y then
            is_grounded = true
        end
    end

    return is_grounded
end

function movement.hits_ceiling(entity)
    local hits_ceiling = false

    -- Check collision for everything one pixel above the entity.
    local x, y, cols, len = entity.bump_world:check(entity, entity.x, entity.y - 1, entity.filter)

    -- Check if the entity hits ceiling.
    for i = 1, len do
        local other = cols[i].other
        local normal = cols[i].normal
        local touch = cols[i].touch
        -- True if item hits solid object and collides from bottom.
        if other.properties.solid and normal.x == 0 and normal.y == 1 and touch.y == entity.y then
            hits_ceiling = true
        end
    end

    return hits_ceiling
end

function movement.hits_wall(entity)
    local hits_wall = false

    -- Sets the wall location to the one in front of the entity.
    local wall_pos = -1
    if entity.facing_right then
        wall_pos = 1
    end

    -- Check collision for everything one pixel in front of the entity.
    local x, y, cols, len = entity.bump_world:check(entity, entity.x + wall_pos, entity.y, entity.filter)

    -- Check if the entity hits wall.
    for i = 1, len do
        local other = cols[i].other
        local normal = cols[i].normal
        local touch = cols[i].touch
        -- True if item hits solid object and collides from behind.
        if other.properties.solid and normal.x == -wall_pos and normal.y == 0 and touch.x == entity.x then
            hits_wall = true
        end
    end

    return hits_wall
end

function movement.horizontal_move(entity, input)
    local x_velocity = 0
    if input.left  then x_velocity = x_velocity - 3 end
    if input.right then x_velocity = x_velocity + 3 end
    entity.velocity.x = x_velocity

    if x_velocity > 0 then
        entity.facing_right = true
    elseif x_velocity < 0 then
        entity.facing_right = false
    end
end