local sti = require "../libs/Simple-Tiled-Implementation/sti"
local bump = require "../libs/bump_lua/bump"

game = {}

function game.enter()
    application.state = game
    love.graphics.setDefaultFilter("nearest")

    map = sti("maps/map_1-1.lua", { "bump" })
    local layer = map:addCustomLayer("Sprites", 3)

    -- Get player spawn object
    local player
    for k, object in pairs(map.objects) do
        if object.name == "Player" then
            player = object
            break
        end
    end

    -- Create the player entity
    local sprite = love.graphics.newImage("assets/player.png")
    layer.player = {
        sprite = sprite,
        x      = player.x,
        y      = player.y,
        ox = 0,
        oy = 0,
    }

    -- Draw the player and a point
    layer.draw = function(self)
        love.graphics.draw(
            self.player.sprite,
            math.floor(self.player.x),
            math.floor(self.player.y),
            0,
            1,
            1,
            self.player.ox,
            self.player.oy
        )
        -- love.graphics.setPointSize(5)
        -- love.graphics.points(math.floor(self.player.x), math.floor(self.player.y))
    end

    layer.update = function(self, dt)
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

        layer.player.x, layer.player.y = world:move(layer.player, layer.player.x + movement.x, layer.player.y + movement.y, false)

        -- if love.keyboard.isDown("w") then
        --     self.player.y = self.player.y - 1
        -- end
        -- if love.keyboard.isDown("s") then
        --     self.player.x = self.player.x + 1
        -- end
        -- if love.keyboard.isDown("r") then
        --     self.player.y = self.player.y + 1
        -- end
        -- if love.keyboard.isDown("a") then
        --     self.player.x = self.player.x - 1
        -- end
    end

    map:removeLayer("Spawn Points")

    -- bump.lua experiment
    world = bump.newWorld(16)
    map:bump_init(world)

    world:add(layer.player, layer.player.x, layer.player.y, 16, 16)
    table.insert(map.bump_collidables, layer.player)
end

function game.update(dt)
    map:update(dt)
end

function game.draw()
    -- Scale world
    local scale = 2
    local screen = { width = love.graphics.getWidth() / scale, height = love.graphics.getHeight() / scale }

    -- Translate world to put the player in the center
    local player = map.layers["Sprites"].player
    local tx = player.x - screen.width / 2
    local ty = player.y - screen.height / 2

    -- Apply world transform
    love.graphics.scale(scale)
    love.graphics.translate(-tx, -ty)

    map:draw()
    map:bump_draw(world)
end