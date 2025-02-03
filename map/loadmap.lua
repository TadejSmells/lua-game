require("map.map")
require("enemy")
loadmap = {}



function loadmap:load()

    self.chosenMap = chosenMap
    local map1 = map:createMap("map/map-layouts/map" .. self.chosenMap .. ".txt")
    
    self.spawnData = {} 


    self.spawnSettings = {
        [1] = { 
            { enemyType = "goblin", spawnInterval = 1, spawnNumber = 5 },
            { enemyType = "orc", spawnInterval = 5, spawnNumber = 3 }
        },
        [2] = { 
            { enemyType = "skeleton", spawnInterval = 4, spawnNumber = 6 },
            { enemyType = "zombie", spawnInterval = 2, spawnNumber = 8 }
        }
    }

    if self.spawnSettings[self.chosenMap] then
        for _, enemyInfo in ipairs(self.spawnSettings[self.chosenMap]) do
            self.spawnData[enemyInfo.enemyType] = {
                spawnTimer = 0,
                spawnCount = 0,
                spawnInterval = enemyInfo.spawnInterval,
                spawnNumber = enemyInfo.spawnNumber
            }
        end
    end
    table.insert(loadmap, map1)
    map1:load()
end


function loadmap:update(dt)
    if not self.chosenMap or not self.spawnData then return end

    for enemyType, data in pairs(self.spawnData) do
        if data.spawnCount < data.spawnNumber then
            data.spawnTimer = data.spawnTimer + dt
            if data.spawnTimer >= data.spawnInterval then
                enemy:spawn(map.spawnPoints, enemyType) -- Pass enemy type
                data.spawnTimer = 0
                data.spawnCount = data.spawnCount + 1
            end
        end
    end
    
    for _, map in ipairs(loadmap) do
        map:update(dt)
    end
end

function loadmap:draw()
    for _, map in ipairs(loadmap) do
        map:draw()
    end
end