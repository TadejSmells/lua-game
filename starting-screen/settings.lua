settings = {}

function settings:load()
    self.options = {"Back", "Player 1: Keyboard", "Player 2: Controller"}
    self.selected = 1
    self.player1Control = "keyboard"  -- Default control for player 1
    self.player2Control = "controller"  -- Default control for player 2
end

function settings:draw()
    love.graphics.printf("Settings", 0, 100, love.graphics.getWidth(), "center")
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