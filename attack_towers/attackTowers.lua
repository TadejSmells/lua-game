attackTowers = {}
local sprite = require("sprite")
require("attack_towers.towerBullet")

towers = {} -- Table to store all placed towers

function attackTowers:load()
    self.originalWidth = 338
    self.originalHeight = 545
end

function attackTowers:spawn(x, y)
    local scaleX = ratio - 0.9
    local scaleY = ratio - 0.9
    
    local tower = {
        x = x,
        y = y,
        width = self.originalWidth * scaleX,
        height = self.originalHeight * scaleY,
        animation = sprite:changeFrames(self.originalWidth, self.originalHeight, 1, "aseprite/tower1.png")
    }

    towerBullet:spawn(tower) -- Pass tower to bullet system
    table.insert(towers, tower)
end

function attackTowers:update(dt)
    if #towers > 0 then
        towerBullet:update(dt)
    end
    
    for _, tower in ipairs(towers) do
        tower.animation:update(dt)
    end
end

function attackTowers:draw()
    local scaleX = ratio - 0.9
    local scaleY = ratio - 0.9
    
    for _, tower in ipairs(towers) do
        love.graphics.draw(
            tower.animation.spriteSheet,
            tower.animation.frames[tower.animation.currentFrame],
            tower.x, tower.y,
            0,
            scaleX, scaleY
        )
    end
end
