require("map.map")
require("enemy")
loadmap = {}


function loadmap:load()
    local map1 = map:createMap("map/map-layouts/map1.txt")
    self.chosenMap = chosenMap
    map1:load()
    if(self.chosenMap == 1) then
        table.insert(loadmap, map1)
        local 
    end
    --[[
    local map2 = map:createMap("map/map-layouts/map2.txt")
    map2:load()
    table.insert(loadmap, map2)]]--
end


function loadmap:update(dt)
    if(self.chosenMap == 1) then
        local currentTime = os.time()
        enemy:spawn(map.spawnPoints)
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