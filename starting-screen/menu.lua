menu = {}

function menu:load()
    self.options = {"Start Game", "Settings", "Quit"}
    self.selected = 1
end

function menu:update(dt)

end

function menu:draw()
    love.graphics.printf("Main Menu", 0, 100, love.graphics.getWidth(), "center")
    for i, option in ipairs(self.options) do
        if i == self.selected then
            love.graphics.setColor(1, 0, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.printf(option, 0, 150 + (i - 1) * 30, love.graphics.getWidth(), "center")
    end
    love.graphics.setColor(1, 1, 1)
end


