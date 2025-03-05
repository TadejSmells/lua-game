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
    self.inRange = false

    self.images = {
        fireRate = love.graphics.newImage("attack_towers/fireRate.png"),
        damage = love.graphics.newImage("attack_towers/damage.png"),
        range = love.graphics.newImage("attack_towers/range.png"),
        speed = love.graphics.newImage("attack_towers/speed.png")
    }
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

function attackTowersUpgrades:upgrade(upgradeType)
    if self.selectedTower.upgradeCount < 4 and not self.selectedTower.upgrades[upgradeType] then
        self.upgradeOptions[upgradeType](self.selectedTower)
        self.selectedTower.upgrades[upgradeType] = true
        self.selectedTower.upgradeCount = self.selectedTower.upgradeCount + 1
    end
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
        self.inRange = true
        self:drawTower(self.selectedTower)
    else
        self.inRange = false
        self.selectedTower = nil
    end
end

function attackTowersUpgrades:drawTower(tower)
    if not tower then return end
    love.graphics.setColor(0, 0, 0, 0.3)
    local radius = 70
    local centerX, centerY = tower.x, tower.y
    love.graphics.circle("fill", centerX, centerY, radius)

    love.graphics.setColor(255, 255, 255)
    local attributes = {"fireRate", "damage", "range", "speed"}
    local angleStep = (2 * math.pi) / #attributes

    for i, attribute in ipairs(attributes) do
        local angle = (i - 1) * angleStep
        local image = self.images[attribute]
        local imageX = centerX + radius * math.cos(angle) - image:getWidth() / 2
        local imageY = centerY + radius * math.sin(angle) - image:getHeight() / 2
        love.graphics.draw(image, imageX, imageY)
        if tower[attribute] then
            love.graphics.print(tower[attribute], imageX + image:getWidth() + 5, imageY)
        end
    end
end