tower = {}

function tower:load()
    self.x = ScreenWidth / 2
    self.y = ScreenHeight / 2
    self.height = 20
    self.width = 10
end


function tower:update()

end

function tower:returnPosition()
    return self.x, self.y
end


function tower:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end