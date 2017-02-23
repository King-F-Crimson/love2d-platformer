require("entity")
require("chili_monster")
require("exit_door")
require("utility")
require("one_way_platform")
require("slope")

local sti = require "../libs/Simple-Tiled-Implementation/sti"
local bump = require "../libs/bump_lua/bump"
local anim8 = require '../libs/anim8/anim8'

world = {
    draw_hitbox = true,
    object_classes = {
        player = player,
        exit_door = exit_door,
        chili_spawner = chili_spawner,
    }
}

function world:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function world:init(game, map)
    self.game = game
    self.map = sti(map, { "bump" })
    self:create_layer("background_entities", 2)
    self:create_layer("entities", 3)
    self:init_bump_world()
    self:create_player()
    self:generate_objects()
    -- self:spawn_entity(chili_monster:new{x = 16, velocity = {x = 0, y = 0}}, self.entities_layer)
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
    self.player.world = self

    self.bump_world:add(self.player, self.player.x + 4, self.player.y, 8, 14)
    self.player.bump_world = self.bump_world
    -- Add the player collidable object to self.map collidables so it's drawn in self.map:bump_draw(world).
    table.insert(self.map.bump_collidables, self.player)
end

function world:init_bump_world()
    self.bump_world = bump.newWorld(16)
    self.map:bump_init(self.bump_world)
    self.bump_world:addResponse("one_way_slide", one_way_slide)
    self.bump_world:addResponse("one_way_bounce", one_way_bounce)
end

function world:generate_objects()
    local objects = self.map.layers["Spawn Points"].objects
    for k, object in pairs(self.map.objects) do
        print(object.name)
        local object_class = self.object_classes[object.name]
        local base_object = {x = object.x, y = object.y, w = object.width, h = object.height, properties = object.properties}
        self:spawn_entity(object_class:new(base_object), self.entities_layer)
    end

    -- Generate exit door
    -- local door_spawn = self:find_object("Exit_Door")
    -- self:spawn_entity(exit_door:new({x = door_spawn.x, y = door_spawn.y, w = door_spawn.width, h = door_spawn.height}),
    --     self.background_entities_layer)
end

function world:spawn_entity(entity, layer)
    table.insert(layer.entities, entity)
    self.bump_world:add(entity, entity.x, entity.y, entity.w, entity.h)
    table.insert(self.map.bump_collidables, entity)

    entity.world = self
    entity.bump_world = self.bump_world
    entity:init()
end

function world:delete_entity(entity)
    -- Container is the table the operation is being applied to.
    local remove_entity = function(k, v, container) 
        if v == entity then
            table.remove(container, k)
        end
    end

    apply_to_all(self.entities_layer.entities, remove_entity)
    apply_to_all(self.background_entities_layer.entities, remove_entity)
    apply_to_all(self.map.bump_collidables, remove_entity)
    self.bump_world:remove(entity)
    entity = nil
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
    love.graphics.push()
    love.graphics.scale(scale)
    love.graphics.translate(-tx, -ty)

    self.map:draw()
    if self.draw_hitbox then
        self.map:bump_draw(self.bump_world)
    end
end