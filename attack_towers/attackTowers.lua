attackTowers = {}
local sprite = require("sprite")
require("attack_towers.towerBullet")
require("players")

function attackTowers:load()
    self.originalWidth = 24
    self.originalHeight = 34
end

towers = {}

towers.towerBaseImages = {
    bow = love.graphics.newImage("attack_towers/img/attackTower.png"),
    minigun = love.graphics.newImage("attack_towers/img/attackTower.png"),
    cannon = love.graphics.newImage("attack_towers/img/attackTower.png"),
}

for _, img in pairs(towers.towerBaseImages) do
    img:setFilter("nearest", "nearest")
end

attackTowers.towerTypes = {
    ["bow"] = { 
        width = 12, height = 12, 
        sprite = towers.towerBaseImages["bow"], 
        animationSprite = "bow.png",
        fireRate = 1, radius = 200, damage = 1
    },
    ["minigun"] = { 
        width = 16, height = 7, 
        sprite = towers.towerBaseImages["minigun"], 
        animationSprite = "minigun.png", 
        fireRate = 0.3, radius = 100, damage = 0.6
    },
    ["cannon"] = { 
        width = 16, height = 12, 
        sprite = towers.towerBaseImages["cannon"], 
        animationSprite = "cannon.png", 
        fireRate = 3, radius = 400, damage = 2
    }
}

function attackTowers:spawn(x, y, towerType)
    local typeData = self.towerTypes[towerType] or self.towerTypes["bow"]

    local scaleX = ratio + 0.4
    local scaleY = ratio + 0.4

    local tower = {
        x = x,
        y = y,
        width = typeData.width * scaleX,
        height = typeData.height * scaleY,
        fireRate = typeData.fireRate, 
        timeSinceLastShot = 0,
        radius = typeData.radius,
        damage = typeData.damage,
        baseImage = typeData.sprite,
        animation = sprite:changeFrames(typeData.width, typeData.height, 1, typeData.animationSprite) -- Animation effect
    }

    towerBullet:spawn(tower)
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
    local scaleX = ratio + 0.4
    local scaleY = ratio + 0.4
    
    for _, tower in ipairs(towers) do
        local centerX = tower.x - (tower.width * scaleX) / 2
        local centerY = tower.y - (tower.height * scaleY) / 2

        love.graphics.draw(tower.baseImage, centerX, centerY, 0, scaleX, scaleY)

        love.graphics.draw(
            tower.animation.spriteSheet,
            tower.animation.frames[tower.animation.currentFrame],
            centerX, centerY,
            0,
            scaleX, scaleY
        )
    end
end
