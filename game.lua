require("player")
require("world")
require("hud")

game = {}

function game:enter(map)
    self.world = world:new()
    self.world:init(map)

    self.hud = hud:new()
    self.hud:init(self.world, self.world.player)

    -- Set the love.keypressed function to change back to menu state and to send signal to the Player object.
    function love.keypressed(key)
        if key == "p" then
            state.enter(menu)
        end
        -- Shorthop can be added by adding the button here without adding it in player:get_control().
        if key == "space" or key == "up" or key == "z" then
            self.world.player:jump_pressed()
        end
        if key == "lctrl" or key == "rctrl" then
            self.world.draw_hitbox = not self.world.draw_hitbox
        end
    end
end

function game:update(dt)
    self.world:update(dt)
end

function game:draw()
    self.world:draw()
    self.hud:draw()
end