require("player")
require("world")

game = {}

function game:enter()
    self.world = world:new()
    self.world:init()

    -- Set the love.keypressed function to change back to menu state and to send signal to the Player object.
    function love.keypressed(key)
        if key == "p" then
            state.enter(menu)
        end
        if key == "space" or key == "up" then
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
end