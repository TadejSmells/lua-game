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

            -- Check if wave is complete
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

        -- ✅ Prevent the wave counter from going above the max waves
        local totalWaves = #self.spawnSettings[self.chosenMap]
        if self.waveTimer == 0 and self.currentWave < totalWaves then
            self.currentWave = self.currentWave + 1
            self:startWave(self.currentWave)
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

    if self.chosenMap and self.spawnSettings[self.chosenMap] then
        local totalWaves = #self.spawnSettings[self.chosenMap]
        local waveText = "Wave: " .. self.currentWave .. " / " .. totalWaves
        local timerText = self.waveActive and "" or ("Next wave in: " .. string.format("%.1f", self.waveTimer) .. "s")

        local screenWidth = love.graphics.getWidth()
        local textX, textY = screenWidth - 150, 10
        local boxWidth, boxHeight = 140, 40

        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", textX - 5, textY - 5, boxWidth, boxHeight, 5, 5)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print(waveText, textX, textY)

        if not self.waveActive then
            love.graphics.print(timerText, textX, textY + 20)
        end

        love.graphics.setColor(1, 1, 1)
    end
end

