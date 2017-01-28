local anim8 = require '../libs/anim8/anim8'

function animate(image_path, length)
	local image = love.graphics.newImage(image_path)
	local grid = anim8.newGrid(16, 16, image:getWidth(), image:getHeight())
	local frame_count = image:getWidth() / 16
	local animation = anim8.newAnimation(grid('1-' .. frame_count, 1), length)
	return animation, image
end