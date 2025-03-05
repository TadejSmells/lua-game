attackTowersUpgrades = {}

function attackTowersUpgrades:load()
    self.availableUpgrades = {"fireRate", "damage", "range", "speed"}
    self.currentUpgradeIndex = 1
    self.upgradeRange = 50
    self.upgradeOptions = {
        ["fireRate"] = function(tower) tower.fireRate = tower.fireRate * 0.75 end,
        ["damage"] = function(tower) tower.damage = tower.damage * 1.5 end,
        ["range"] = function(tower) tower.radius = tower.radius * 1.25 end,
        ["speed"] = function(tower) tower.speed = tower.speed + 50 end,
    }
    self.selectedTower = nil
    self.selectedPlayer = nil
end

function attackTowersUpgrades:getClosestTower(playerX, playerY)
    local closestTower = nil
    local minDist = attackTowersUpgrades.upgradeRange
    for _, tower in ipairs(towers) do
        local dist = math.sqrt((tower.x - playerX)^2 + (tower.y - playerY)^2)
        if dist < minDist then
            minDist = dist
            closestTower = tower
        end
    end
    return closestTower
end

function attackTowersUpgrades:showUpgradeMenu(tower, player)
    self.selectedTower = tower
    self.selectedPlayer = player
end

function attackTowersUpgrades:isPlayerInRange(playerX, playerY)
    if not self.selectedTower then return false end
    local dist = math.sqrt((self.selectedTower.x - playerX)^2 + (self.selectedTower.y - playerY)^2)
    return dist < self.upgradeRange
end

function attackTowersUpgrades:draw()
        if self.selectedTower and self:isPlayerInRange(self.selectedPlayer.x, self.selectedPlayer.y) then
            self:drawTower(self.selectedTower)
        else
            self.selectedTower = nil
        end
end

function attackTowersUpgrades:drawTower(tower)
    if not tower then return end
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Selected Tower", 10, 10)
    love.graphics.print("Fire Rate: " .. tower.fireRate, 10, 30)
    love.graphics.print("Damage: " .. tower.damage, 10, 50)
    love.graphics.print("Range: " .. tower.radius, 10, 70)
    love.graphics.print("Speed: " .. tower.speed, 10, 90)
end