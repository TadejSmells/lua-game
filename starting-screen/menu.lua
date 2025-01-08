function menu:load()
    self.options = {"Start Game", "Settings", "Quit"}
    self.selected = 1 -- Tracks the currently selected menu option
end

function menu:update(dt)
    if love.keyboard.isDown("up") then
        self.selected = self.selected - 1
        if self.selected < 1 then self.selected = #self.options end
    elseif love.keyboard.isDown("down") then
        self.selected = self.selected + 1
        if self.selected > #self.options then self.selected = 1 end
    elseif love.keyboard.isDown("return") then
        if self.selected == 1 then
            gameState = "playing"
        elseif self.selected == 2 then
            gameState = "settings"
        elseif self.selected == 3 then
            love.event.quit()
        end
    end
end

function menu:draw()
    love.graphics.printf("Main Menu", 0, 100, love.graphics.getWidth(), "center")
    for i, option in ipairs(self.options) do
        if i == self.selected then
            love.graphics.setColor(1, 0, 0) -- Highlight selected option
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.printf(option, 0, 150 + (i - 1) * 30, love.graphics.getWidth(), "center")
    end
    love.graphics.setColor(1, 1, 1) -- Reset color
end
