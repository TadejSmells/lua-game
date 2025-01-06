require("map.map")
loadmap = {}


function loadmap:load()
    local map1 = map:createMap("map/map-layouts/map1.txt")
    map1:load()
    table.insert(loadmap, map1)

    local map2 = map:createMap("map/map-layouts/map2.txt")
    map2:load()
    table.insert(loadmap, map2)
end


function loadmap:update(dt)
    for _, map in ipairs(loadmap) do
        map:update(dt)
    end
end

function loadmap:draw()
    for _, map in ipairs(loadmap) do
        map:draw()
    end
end