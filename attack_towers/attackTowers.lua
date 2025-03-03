attackTowers = {}
local sprite = require("sprite")
require("attack_towers.towerBullet")

towers = {}

attackTowers.towerTypes = {
    ["basic"] = { 
        width = 338, height = 545, sprite = "aseprite/tower1.png", fireRate = 1, radius = 200
    },
    ["rapid"] = { 
        width = 300, height = 500, sprite = "aseprite/tower1.png", fireRate = 0.5, radius = 150
    },
    ["sniper"] = { 
        width = 350, height = 600, sprite = "aseprite/tower1.png", fireRate = 2, radius = 300
    }
}

function attackTowers:load()
    self.originalWidth = 338
    self.originalHeight = 545
end

function attackTowers:spawn(x, y, towerType)
    local typeData = self.towerTypes[towerType] or self.towerTypes["basic"]

    local scaleX = ratio - 0.9
    local scaleY = ratio - 0.9

    local tower = {
        x = x,
        y = y,
        width = typeData.width * scaleX,
        height = typeData.height * scaleY,
        fireRate = typeData.fireRate, 
        timeSinceLastShot = 0,
        radius = typeData.radius,
        animation = sprite:changeFrames(typeData.width, typeData.height, 1, typeData.sprite)
    }

    towerBullet:spawn(tower)
    table.insert(towers, tower)
end


function attackTowers:setTowerType(towerType)
    if self.towerTypes[towerType] then
        self.selectedTowerType = towerType
    end
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
