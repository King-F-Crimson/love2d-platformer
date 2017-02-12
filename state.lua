state = {}

function state.enter(new_state, state_args)
	-- state_args is an additional argument for some state (e.g. map, victory condition).
    application.state = new_state
    love.keypressed = nil

    if state_args == nil then
    	new_state:enter()
    else
    	new_state:enter(state_args)
    end
end