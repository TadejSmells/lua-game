attackTowers = {}
local sprite = require("sprite")

function attackTowers:load()
    self.originalWidth = 338
    self.originalHeight = 545

    local scaleX = ratio - 0.7
    local scaleY = ratio - 0.7

    self.width = self.originalWidth * scaleX
    self.height = self.originalHeight * scaleY
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    self.animation = sprite:changeFrames(self.originalWidth, self.originalHeight, 6, "attackTowers-main.png")

    

    self.x = (screenWidth - (self.originalWidth * scaleX)) / 2
    self.y = (screenHeight / 2) - (self.originalHeight * scaleY)

    self.health = 100
end

function attackTowers:update(dt)
    self.animation:update(dt)
end

function attackTowers:takeDamage(amount)
    self.health = math.max(0, self.health - amount)
    if self.health == 0 then
        love.event.quit( "restart" )
    end
end

function attackTowers:returnPosition()
    return self.x, self.y
end

function attackTowers:draw()
    local scaleX = ratio - 0.7
    local scaleY = ratio - 0.7

    love.graphics.draw(
        self.animation.spriteSheet,
        self.animation.frames[self.animation.currentFrame],
        self.x, self.y,
        0,
        scaleX, scaleY
    )
end
