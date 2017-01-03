require("run")
require("state")
require("states/menu")
require("states/game")

application = {}

function love.load()
    love.window.setMode(768, 512)

    state.enter(menu)
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.push("quit")
    end

    application.state.update(dt)
end

function love.draw()
    application.state.draw()
end