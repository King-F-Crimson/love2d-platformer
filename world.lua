require("entity")
require("chili_monster")
require("exit_door")

local sti = require "../libs/Simple-Tiled-Implementation/sti"
local bump = require "../libs/bump_lua/bump"
local anim8 = require '../libs/anim8/anim8'

world = {
    draw_hitbox = true
}

function world:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function world:init(map)
    self.map = sti(map, { "bump" })
    self:create_layer("background_entities", 2)
    self:create_layer("entities", 3)
    self:create_player()
    self:init_bump_world()

    self:spawn_entity(chili_monster:new{velocity = {x = 0, y = 0}}, self.entities_layer)

    local door_spawn = self:find_object("Exit_Door")
    self:spawn_entity(exit_door:new({x = door_spawn.x, y = door_spawn.y, w = door_spawn.width, h = door_spawn.height}),
        self.background_entities_layer)
end

function world:create_layer(name, level)
    local layer_name = name .. "_layer"
    self[layer_name] = self.map:addCustomLayer(name, level)
    local layer = self[layer_name]
    layer.entities = {}

    -- Create method to draw and update every entities in the layer.
    function layer:draw()
        for k, entity in pairs(self.entities) do
            entity:draw()
        end
    end

    function layer:update(dt)
        for k, entity in pairs(self.entities) do
            entity:update(dt)
        end
    end
end

function world:find_object(name)
    local target
    for k, object in pairs(self.map.objects) do
        if object.name == name then
            target = object
            break
        end
    end
    return target
end

function world:create_player()
    -- Get player spawn object.
    local player_spawn = self:find_object("Player")

    -- Create the player entity.
    self.entities_layer.entities.player = player:new()
    self.entities_layer.entities.player:init(player_spawn)

    self.player = self.entities_layer.entities.player
end

function world:create_exit_door()
    local door_spawn = self:find_object("Exit_Door")

    self.background_entities_layer.entities.exit_door = exit_door:new()
    self.background_entities_layer.entities.exit_door:init(door_spawn)

    self.exit_door = self.background_entities_layer.entities.exit_door
end

function world:init_bump_world()
    self.bump_world = bump.newWorld(16)
    self.map:bump_init(self.bump_world)
    -- When the entities are added to the bump world should be changed.
    -- Add the player object to the world.
    self.bump_world:add(self.player, self.player.x, self.player.y, 16, 16)
    self.player.world = self.bump_world
    -- Add the player collidable object to self.map collidables so it's drawn in self.map:bump_draw(world).
    table.insert(self.map.bump_collidables, self.player)
end

function world:spawn_entity(entity, layer)
    table.insert(layer.entities, entity)
    self.bump_world:add(entity, entity.x, entity.y, entity.w, entity.h)
    table.insert(self.map.bump_collidables, entity)

    entity.world = self.bump_world
    entity:init()
end

function world:update(dt)
    self.map:update(dt)
end

function world:draw()
    -- Scale world
    local scale = 2
    local screen = { width = love.graphics.getWidth() / scale, height = love.graphics.getHeight() / scale }

    -- Translate world to put the player in the center
    local player = self.entities_layer.entities.player
    local tx = player.x - screen.width / 2
    local ty = player.y - screen.height / 2

    -- Apply world transform
    love.graphics.scale(scale)
    love.graphics.translate(-tx, -ty)

    self.map:draw()
    if self.draw_hitbox then
        self.map:bump_draw(self.bump_world)
    end
end