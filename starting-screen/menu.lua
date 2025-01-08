menu = {}

function menu:load()
    self.options = {"Start Game", "Settings", "Quit"}
    self.selected = 1
end

function menu:update(dt)

end

function love.keypressed(key, scancode, isrepeat)
    if key == "up" then
        menu.selected = menu.selected - 1
        if menu.selected < 1 then menu.selected = #menu.options end
    elseif key == "down" then
        menu.selected = menu.selected + 1
        if menu.selected > #menu.options then menu.selected = 1 end
    elseif key == "return" then
        if menu.selected == 1 then
            gameState = "playing"
        elseif menu.selected == 2 then
            gameState = "settings"
        elseif menu.selected == 3 then
            love.event.quit()
        end
    end
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


