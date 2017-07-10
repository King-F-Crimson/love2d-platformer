require("entity")
require("chili_monster")
require("exit_door")
require("utility")
require("one_way_platform")
require("spawner")
require("cash")

local sti = require "../libs/Simple-Tiled-Implementation/sti"
local bump = require "../libs/bump_lua/bump"
local anim8 = require '../libs/anim8/anim8'

world = {
    draw_hitbox = true,
    object_class = {
        player_spawn = player,
        exit_door = exit_door,
        chili_spawner = chili_spawner,
        cash = cash,
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
    self:create_layer_for_entities("background_entities", 3)
    self:create_layer_for_entities("entities", 4)
    self:init_bump_world()
    self:generate_objects()

    self.player = self:find_object("player")
    self.map:bump_removeLayer("spawn_points", self.bump_world)
    self.map:removeLayer("spawn_points")
end

function world:create_layer_for_entities(name, level)
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

function world:init_bump_world()
    self.bump_world = bump.newWorld(16)
    self.map:bump_init(self.bump_world)
    self.bump_world:addResponse("one_way_slide", one_way_slide)
    self.bump_world:addResponse("one_way_bounce", one_way_bounce)
end

function world:generate_objects()
    local objects = self.map.layers["spawn_points"].objects
    for k, object in pairs(objects) do
        local object_class = self.object_class[object.name]
        local base_object = {x = object.x, y = object.y, w = object.width, h = object.height, properties = object.properties}

        local layer = self.entities_layer
        if object.properties.background then
            layer = self.background_entities_layer
        end
        self:spawn_entity(object_class:new(base_object), layer)
    end
end

function world:spawn_entity(entity, layer)
    table.insert(layer.entities, entity)
    table.insert(self.map.objects, entity)
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

function world:check_distance(object1, object2)
    return math.abs(object1.x - object2.x), math.abs(object1.y - object2.y)
end

function world:update(dt)
    self.map:update(dt)
end

function world:draw()
    -- Scale world
    local scale = 2
    local screen = { width = love.graphics.getWidth() / scale, height = love.graphics.getHeight() / scale }

    -- Translate world to put the player in the center
    local player = self.player
    local tx = player.x - screen.width / 2 + player.w / 2
    local ty = player.y - screen.height / 2 + player.w / 2

    -- Apply world transform
    love.graphics.push()

    self.map:draw(-tx, -ty, scale, scale)
    if self.draw_hitbox then
        self.map:bump_draw(self.bump_world, -tx, -ty, scale, scale)
    end
    love.graphics.pop()
end