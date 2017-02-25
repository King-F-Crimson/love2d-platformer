require("player")
require("world")
require("hud")
require("pause_menu")

game = {
    pause_sound = love.audio.newSource("assets/pause.mp3", "static"),
}

function game:enter(map)
    self.world = world:new()
    self.world:init(self, map)

    self.hud = hud:new()
    self.hud:init(self.world, self.world.player)

    self.pause_menu = pause_menu:new()
    self.paused = false

    self.frame_count = 0

    self:set_control()
end

function game:set_control()
    -- Set the love.keypressed function to change back to menu state and to send signal to the Player object.
    function love.keypressed(key)
        if key == "p" then
            state.enter(menu_state)
        end
        if key == "escape" then
            self:pause()
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

function game:pause()
    self.paused = true
    self.pause_menu:init(self)
    self.pause_sound:play()
end

function game:finish(win)
    local args = {
        time = self.frame_count / 60,
        win = win
    }
    state.enter(result, args)
end

function game:update(dt)
    if not self.paused then
        self.world:update(dt)
    end
    self.frame_count = self.frame_count + 1
end

function game:draw()
    self.world:draw()
    self.hud:draw()
    if self.paused then
        self.pause_menu:draw()
    end
end