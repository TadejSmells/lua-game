tower = {}
local sprite = require("sprite")

function tower:load()
    self.originalWidth = 338
    self.originalHeight = 545
    self.width = self.originalWidth / 10
    self.height = self.originalHeight / 10
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    self.animation = sprite:changeFrames(self.originalWidth, self.originalHeight, 6, "Tower-main.png")

    local scaleX = ratio - 0.7
    local scaleY = ratio - 0.7

    self.x = (screenWidth - (self.originalWidth * scaleX)) / 2
    self.y = (screenHeight / 2) - (self.originalHeight * scaleY)

    self.health = 100
end

function tower:update(dt)
    self.animation:update(dt)
end

function tower:takeDamage(amount)
    self.health = math.max(0, self.health - amount)
end

function tower:returnPosition()
    return self.x, self.y
end

function tower:draw()
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
