require("entity")
require("movement")

chili_monster = entity:new({
	w = 16,
	h = 16,
	sprite = love.graphics.newImage("assets/Mexican_Chili_Monster.png"),
	state = standing
})

function chili_monster:get_control()
	local control = {}

	-- Move to the direction it's facing
	if self.facing_right then
		control.right = true
		control.left = false
	else
		control.right = false
		control.left = true
	end

	-- If hitting wall, reverse the direction
	if movement.hits_wall(self) then
		control.right = not control.right
		control.left = not control.left
	end

	return control
end