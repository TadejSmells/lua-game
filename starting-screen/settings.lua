settings = {}

function settings:load()
    self.options = {"Back"}
    self.selected = 1
    
end

function settings:update(dt)

end

function settings:draw()
    love.graphics.printf("Settings", 0, 100, love.graphics.getWidth(), "center")
    love.graphics.printf("Press Enter to return to Menu", 0, 150, love.graphics.getWidth(), "center")
end
