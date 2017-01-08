grounded = {}
airborne = {}

function grounded.move(entity)
    entity.velocity.y = 0

    if love.keyboard.isDown("space") then
        grounded.jump(entity)
    end
    if love.keyboard.isDown("left") then
        accelerate(entity, -entity.acceleration, entity.max_speed)
    end
    if love.keyboard.isDown("right") then
        accelerate(entity, entity.acceleration, entity.max_speed)
    end

    apply_friction(entity)

    entity.x, entity.y = world:move(entity, entity.x + entity.velocity.x, entity.y + entity.velocity.y)

    if not is_grounded(entity) then
        entity.state = airborne
    end
end

function grounded.jump(entity)
    entity.velocity.y = -10
    entity.state = airborne
end

function airborne.move(entity)
    entity.velocity.y = entity.velocity.y + 0.4

    if love.keyboard.isDown("left") then
        accelerate(entity, -entity.acceleration, entity.max_speed)
    end
    if love.keyboard.isDown("right") then
        accelerate(entity, entity.acceleration, entity.max_speed)
    end

    apply_friction(entity)

    entity.x, entity.y, cols, len = world:move(entity, entity.x + entity.velocity.x, entity.y + entity.velocity.y)

    if is_grounded(entity) then
        entity.state = grounded
    end
    if hits_ceiling(entity) then
        entity.velocity.y = 0
    end
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

function accelerate(entity, a, max_speed)
    entity.velocity.x = entity.velocity.x + a
    -- Cap the speed at the limit, both negative or positive velocity.
    if entity.velocity.x > max_speed then
        entity.velocity.x = max_speed
    elseif entity.velocity.x < -max_speed then
        entity.velocity.x = -max_speed
    end
end

-- TODO: set the velocity to 0 when close enough to 0
function apply_friction(entity, a, max_speed)
    entity.velocity.x = entity.velocity.x * 0.8
end