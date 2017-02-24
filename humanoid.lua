require("movement")
require("entity")

humanoid = entity:new({

})

function humanoid:draw()
    local animation = self.animation[self.state]
    local sprite = self.sprite[self.state]

    if self.facing_right then
        animation:draw(sprite, self.x, self.y, 0, 1, 1, self.origin.x, self.origin.y)
    else
        animation:draw(sprite, self.x + self.w, self.y, 0, -1, 1, self.origin.x, self.origin.y)
    end
end

function humanoid:move(control)
    self.state.move(self, control)
    movement.update_spatial(self)
end