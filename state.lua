state = {}

function state.enter(new_state, map)
	-- map argument is only required for game state.
    application.state = new_state
    love.keypressed = nil

    if map == nil then
    	new_state:enter()
    else
    	new_state:enter(map)
    end
end