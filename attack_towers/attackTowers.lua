attackTowers = {}
local sprite = require("sprite")
require("attack_towers.towerBullet")

function attackTowers:load()
    towerBullet:load()
    self.originalWidth = 338
    self.originalHeight = 545

    local scaleX = ratio - 0.9
    local scaleY = ratio - 0.9

    self.width = self.originalWidth * scaleX
    self.height = self.originalHeight * scaleY
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    self.x = 200
    self.y = 200
    self.animation = sprite:changeFrames(self.originalWidth, self.originalHeight, 1, "aseprite/tower1.png")
end

function attackTowers:update(dt)
    towerBullet:update(dt)
    self.animation:update(dt)
end

function attackTowers:draw()
    local scaleX = ratio - 0.9
    local scaleY = ratio - 0.9

    love.graphics.draw(
        self.animation.spriteSheet,
        self.animation.frames[self.animation.currentFrame],
        self.x, self.y,
        0,
        scaleX, scaleY
    )

    -- Draw bullets
end


