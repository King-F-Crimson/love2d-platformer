local sti = require "../libs/Simple-Tiled-Implementation/sti"
local bump = require "../libs/bump_lua/bump"
local anim8 = require '../libs/anim8/anim8'

require("player")

game = {}

function game:enter()
    self.map = sti("maps/map_1-2.lua", { "bump" })
    local layer = self.map:addCustomLayer("Sprites", 3)

    -- Get player spawn object
    local player_spawn
    for k, object in pairs(self.map.objects) do
        if object.name == "Player" then
            player_spawn = object
            break
        end
    end

    -- Create the player entity
    layer.entities = {}
    layer.entities.player = player:new()
    layer.entities.player:init(player_spawn)

    -- Draw the every entity in the layer.
    function layer:draw()
        for k, entity in pairs(self.entities) do
            entity:draw()
        end
    end

    layer.update = function(self, dt)
        for k, entity in pairs(self.entities) do
            entity:update(dt)
        end
    end

    self.map:removeLayer("Spawn Points")

    -- bump.lua experiment
    world = bump.newWorld(16)
    self.map:bump_init(world)

    world:add(layer.entities.player, layer.entities.player.x, layer.entities.player.y, 16, 16)
    layer.entities.player.world = world
    -- Add the player collidable object to self.map collidables so it's drawn in self.map:bump_draw(world)
    table.insert(self.map.bump_collidables, layer.entities.player)

    -- Set the love.keypressed function to change back to menu state and to send signal to the Player object.
    function love.keypressed(key)
        if key == "p" then
            state.enter(menu)
        end
        if key == "space" or key == "up" then
            layer.entities.player:jump_pressed()
        end
    end
end

function game:update(dt)
    self.map:update(dt)
end

function game:draw()
    -- Scale world
    local scale = 2
    local screen = { width = love.graphics.getWidth() / scale, height = love.graphics.getHeight() / scale }

    -- Translate world to put the player in the center
    local player = self.map.layers["Sprites"].entities.player
    local tx = player.x - screen.width / 2
    local ty = player.y - screen.height / 2

    -- Apply world transform
    love.graphics.scale(scale)
    love.graphics.translate(-tx, -ty)

    self.map:draw()
    self.map:bump_draw(world)
end