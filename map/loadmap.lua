require("map.map")
require("enemy")

loadmap = {}

function loadmap:load()
    self.chosenMap = chosenMap
    local map1 = map:createMap("map/map-layouts/map" .. self.chosenMap .. ".txt")

    self.currentWave = 1
    self.spawnTimer = 0
    self.waveActive = false
    self.waveCooldown = 5
    self.waveTimer = 0

    self.spawnSettings = {
        [1] = {
            { waveNumber = 1, spawnInterval = 1, enemies = { goblin = 5, orc = 3 } },
            { waveNumber = 2, spawnInterval = 1, enemies = { goblin = 10, orc = 5 } }
        },
        [2] = {
            { waveNumber = 1, spawnInterval = 3, enemies = { skeleton = 6, zombie = 8 } },
            { waveNumber = 2, spawnInterval = 3, enemies = { skeleton = 12, zombie = 10 } }
        }
    }

    if self.spawnSettings[self.chosenMap] then
        self:startWave(self.currentWave)
    end

    table.insert(loadmap, map1)
    map1:load()
end

function loadmap:update(dt)
    if not self.chosenMap then return end

    if self.waveActive then
        local waveData = self.spawnSettings[self.chosenMap][self.currentWave]
        if waveData then
            self.spawnTimer = self.spawnTimer + dt

            if self.spawnTimer >= waveData.spawnInterval then
                self.spawnTimer = 0
                for enemyType, remaining in pairs(self.remainingEnemies) do
                    if remaining > 0 then
                        enemy:spawn(map.spawnPoints, enemyType)
                        self.remainingEnemies[enemyType] = remaining - 1
                        break
                    end
                end
            end

            local waveComplete = true
            for _, count in pairs(self.remainingEnemies) do
                if count > 0 then
                    waveComplete = false
                    break
                end
            end

            if waveComplete then
                self.waveActive = false
                self.waveTimer = self.waveCooldown
            end
        end
    else
        self.waveTimer = math.max(0, self.waveTimer - dt)
        if self.waveTimer == 0 then
            self.currentWave = self.currentWave + 1
            if self.spawnSettings[self.chosenMap][self.currentWave] then
                self:startWave(self.currentWave)
            end
        end
    end

    for _, map in ipairs(loadmap) do
        map:update(dt)
    end
end

function loadmap:startWave(waveNumber)
    local waveData = self.spawnSettings[self.chosenMap][waveNumber]
    if not waveData then return end

    self.remainingEnemies = {}

    -- Store how many of each enemy type need to be spawned
    for enemyType, count in pairs(waveData.enemies) do
        self.remainingEnemies[enemyType] = count
    end

    self.spawnTimer = 0
    self.waveActive = true
end

function loadmap:draw()
    for _, map in ipairs(loadmap) do
        map:draw()
    end
end
