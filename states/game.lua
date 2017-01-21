local sti = require "../libs/Simple-Tiled-Implementation/sti"
local bump = require "../libs/bump_lua/bump"

require("../player")

game = {}

function game.enter()
    map = sti("maps/map_1-2.lua", { "bump" })
    local layer = map:addCustomLayer("Sprites", 3)

    -- Get player spawn object
    local player_spawn
    for k, object in pairs(map.objects) do
        if object.name == "Player" then
            player_spawn = object
            break
        end
    end

    -- Create the player entity
    layer.player = player:new()

    local sprite = love.graphics.newImage("assets/player.png")
    local air_sprite = love.graphics.newImage("assets/player_air.png")
    layer.player.sprite = sprite
    layer.player.air_sprite = air_sprite
    layer.player.x      = player_spawn.x
    layer.player.y      = player_spawn.y

    -- Draw the player and a point
    layer.draw = function(self)
        self.player:draw()
    end

    layer.update = function(self, dt)
        self.player:update()
    end

    map:removeLayer("Spawn Points")

    -- bump.lua experiment
    world = bump.newWorld(16)
    map:bump_init(world)

    world:add(layer.player, layer.player.x, layer.player.y, 16, 16)
    layer.player.world = world
    -- Add the player collidable object to map collidables so it's drawn in map:bump_draw(world)
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