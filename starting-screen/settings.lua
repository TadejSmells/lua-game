settings = {}

function settings:load()
    self.options = {"Back"}
    self.selected = 1
    
end

function settings:update(dt)
    if gameState == "settings" then
        function love.keypressed(key, scancode, isrepeat)
            if key == "return" then
                gameState = "menu"
            end
        end
    end
end




function settings:draw()
    love.graphics.printf("Settings", 0, 100, love.graphics.getWidth(), "center")
    love.graphics.printf("Press Enter to return to Menu", 0, 150, love.graphics.getWidth(), "center")
end
