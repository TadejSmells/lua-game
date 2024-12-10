bullet = {}


function bullet:load()
    self.x = ScreenWidth / 2
    self.y = ScreenHeight / 2
    self.height = 3
    self.width = 3
end


function bullet:update()

end



function bullet:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end