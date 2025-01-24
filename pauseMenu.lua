pauseMenu = {}

function pauseMenu:load()
    self.options = {"Resume", "Settings", "Main menu"}
    self.selected = 1
end

function pauseMenu:update(dt)

end


function pauseMenu:draw()
    -- Define the menu box dimensions
    local menuWidth, menuHeight = 500, 500
    local menuX = (love.graphics.getWidth() - menuWidth) / 2
    local menuY = (love.graphics.getHeight() - menuHeight) / 2

    -- Draw the menu background
    love.graphics.setColor(0, 0, 0, 0.7) -- Semi-transparent black
    love.graphics.rectangle("fill", menuX, menuY, menuWidth, menuHeight)

    -- Draw the menu border
    love.graphics.setColor(1, 1, 1) -- White border
    love.graphics.rectangle("line", menuX, menuY, menuWidth, menuHeight)

    -- Draw the menu options
    for i, option in ipairs(self.options) do
        local textY = menuY + 50 + (i - 1) * 30 -- Adjust vertical spacing
        if i == self.selected then
            love.graphics.setColor(1, 0, 0) -- Highlight selected option
        else
            love.graphics.setColor(1, 1, 1) -- Default color
        end
        love.graphics.printf(option, menuX, textY, menuWidth, "center")
    end

    -- Reset the color
    love.graphics.setColor(1, 1, 1)
end
