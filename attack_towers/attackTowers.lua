attackTowers = {}
local sprite = require("sprite")
require("attack_towers.towerBullet")

function attackTowers:load()
    self.originalWidth = 70
    self.originalHeight = 130
end

towers = {}

towers.towerBaseImages = {
    bow = love.graphics.newImage("attack_towers/img/upgrade0.png"),
    minigun = love.graphics.newImage("attack_towers/img/upgrade0.png"),
    cannon = love.graphics.newImage("attack_towers/img/upgrade0.png"),
}

for _, img in pairs(towers.towerBaseImages) do
    img:setFilter("nearest", "nearest")
end

attackTowers.towerTypes = {
    ["bow"] = { 
        width = 48, height = 48, 
        sprite = towers.towerBaseImages["bow"], 
        animationSprite = "attack_towers/img/idle.png",
        fireRate = 1, radius = 200, damage = 1, speed = 300
    },
    ["minigun"] = { 
        width = 48, height = 48, 
        sprite = towers.towerBaseImages["minigun"], 
        animationSprite = "attack_towers/img/idle.png", 
        fireRate = 0.3, radius = 100, damage = 0.6, speed = 400
    },
    ["cannon"] = { 
        width = 48, height = 48, 
        sprite = towers.towerBaseImages["cannon"], 
        animationSprite = "attack_towers/img/idle.png",
        fireRate = 3, radius = 400, damage = 2, speed = 250
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
        speed = typeData.speed,
        baseImage = typeData.sprite,
        animation = sprite:changeFrames(typeData.width, typeData.height, 4, typeData.animationSprite),
        upgrades = {},
        upgradeCount = 0
    }

    towerBullet:spawn(tower)
    table.insert(towers, tower)
end

function attackTowers:selectNextTower(player)
    if #towers > 0 then
        if not player.selectedTowerIndex then
            player.selectedTowerIndex = 1
        else
            player.selectedTowerIndex = (player.selectedTowerIndex % #towers) + 1
        end
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
    local scaleX = ratio - 0.1
    local scaleY = ratio - 0.1
    
    for index, tower in ipairs(towers) do
        local centerX = tower.x - (tower.width * scaleX) / 2
        local centerY = tower.y - (tower.height * scaleY) / 2 - 55

        love.graphics.draw(tower.baseImage, centerX, centerY, 0, scaleX, scaleY)

        -- Adjust the animation drawing coordinates to center it on top of the tower
        local animationCenterX = tower.x - (tower.animation.frameWidth * scaleX) / 2
        local animationCenterY = tower.y - (tower.animation.frameHeight * scaleY) / 2

        love.graphics.draw(
            tower.animation.spriteSheet,
            tower.animation.frames[tower.animation.currentFrame],
            animationCenterX, animationCenterY,
            0,
            scaleX, scaleY
        )
        
        for _, player in ipairs(players) do
            if index == player.selectedTowerIndex then
                love.graphics.setColor(0, 1, 0, 1)
                love.graphics.rectangle("line", centerX, centerY, tower.width, tower.height)
                love.graphics.setColor(1, 1, 1, 1)
            end
        end
    end
end