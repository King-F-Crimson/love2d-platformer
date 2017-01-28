state = {}

function state.enter(new_state)
    application.state = new_state
    love.keypressed = nil

    new_state:enter()
end