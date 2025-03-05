attackTowers = {}
local sprite = require("sprite")
require("attack_towers.towerBullet")

function attackTowers:load()
    self.originalWidth = 24
    self.originalHeight = 34
    self.availableUpgrades = {"fireRate", "damage", "range", "speed"}
    self.currentUpgradeIndex = 1
    self.upgradeRange = 50  -- Define how close the player must be to a tower to upgrade it
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
        fireRate = 1, radius = 200, damage = 1, speed = 300
    },
    ["minigun"] = { 
        width = 16, height = 7, 
        sprite = towers.towerBaseImages["minigun"], 
        animationSprite = "minigun.png", 
        fireRate = 0.3, radius = 100, damage = 0.6, speed = 400
    },
    ["cannon"] = { 
        width = 16, height = 12, 
        sprite = towers.towerBaseImages["cannon"], 
        animationSprite = "cannon.png", 
        fireRate = 3, radius = 400, damage = 2, speed = 250
    }
}

attackTowers.upgradeOptions = {
    ["fireRate"] = function(tower) tower.fireRate = tower.fireRate * 0.75 end,
    ["damage"] = function(tower) tower.damage = tower.damage * 1.5 end,
    ["range"] = function(tower) tower.radius = tower.radius * 1.25 end,
    ["speed"] = function(tower) tower.speed = tower.speed + 50 end,
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
        animation = sprite:changeFrames(typeData.width, typeData.height, 1, typeData.animationSprite),
        upgrades = {},
        upgradeCount = 0
    }

    towerBullet:spawn(tower)
    table.insert(towers, tower)
end

function attackTowers:getClosestTower(playerX, playerY)
    local closestTower = nil
    local minDist = attackTowers.upgradeRange
    for _, tower in ipairs(towers) do
        local dist = math.sqrt((tower.x - playerX)^2 + (tower.y - playerY)^2)
        if dist < minDist then
            minDist = dist
            closestTower = tower
        end
    end
    return closestTower
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

function attackTowers:cycleUpgrade(player)
    player.currentUpgradeIndex = (player.currentUpgradeIndex % #self.availableUpgrades) + 1
end

function attackTowers:upgrade(tower, upgradeType)
    if tower.upgradeCount < 2 and not tower.upgrades[upgradeType] then
        self.upgradeOptions[upgradeType](tower)
        tower.upgrades[upgradeType] = true
        tower.upgradeCount = tower.upgradeCount + 1
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

function attackTowers:handleInput(player)
    if love.keyboard.isDown("u") then
        self:upgradeClosestTower(player)
    end
    if love.keyboard.isDown("t") then
        self:selectNextTower(player)
    end
    if love.keyboard.isDown("y") then
        self:cycleUpgrade(player)
    end
end

function attackTowers:draw()
    local scaleX = ratio + 0.4
    local scaleY = ratio + 0.4
    
    for index, tower in ipairs(towers) do
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
        
        for _, player in ipairs(players) do
            if index == player.selectedTowerIndex then
                love.graphics.setColor(0, 1, 0, 1)
                love.graphics.rectangle("line", centerX, centerY, tower.width, tower.height)
                love.graphics.setColor(1, 1, 1, 1)
            end
        end
    end
end