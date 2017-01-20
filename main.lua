require("run")
require("state")
require("states/menu")

application = {}
application.assets = {}

function love.load()
    love.window.setMode(768, 512)
    love.graphics.setDefaultFilter("nearest")

    application.assets.font = love.graphics.newImageFont("assets/Resource-Imagefont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
    application.assets.font:setFilter( "nearest" )

    love.graphics.setFont(application.assets.font)

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