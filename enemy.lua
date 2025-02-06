require("shoot")

local sprite = require("sprite")
enemy = {}
enemies = {}


function enemy:load()
    self.height = spriteHeight
    self.width = spriteWidth
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    self.animation = sprite:changeFrames(44, 30, 1, "enemy.png")
end

function enemy:spawn(spawnPoints)
    local skeleton = {}
    skeleton.speed = 200
    skeleton.health = 3
    local firstSpawnPoint = spawnPoints[1]
    --print(firstSpawnPoint.x)
    --print(firstSpawnPoint.y)
    skeleton.x = (firstSpawnPoint.x-1) * tileSize
    skeleton.y = (firstSpawnPoint.y-1) * tileSize

    -- Assign enemy width and height
    skeleton.width = self.width
    skeleton.height = self.height

    table.insert(enemies, skeleton)
    --print("Enemy spawned")
end


--[[

function enemy:spawn()
    if love.keyboard.isDown("h") then 
        local skeleton = {}
        skeleton.speed = 100
        skeleton.health = 3
        local spawnSide = math.random(1,4)
        if spawnSide == 1 then 
            skeleton.x = screenWidth * (-0.1)
            skeleton.y = math.random((screenHeight*0.1), (screenHeight-(screenHeight*0.1)))
        elseif spawnSide == 2 then
            skeleton.y = screenHeight * (-0.1)
            skeleton.x = math.random((screenWidth*0.1), (screenWidth-(screenWidth*0.1)))
        elseif spawnSide == 3 then
            skeleton.x = screenWidth + (screenWidth * 0.1)
            skeleton.y = math.random((screenHeight*0.1), (screenHeight-(screenHeight*0.1)))
        elseif spawnSide == 4 then
            skeleton.y = screenHeight + (screenHeight * 0.1)
            skeleton.x = math.random((screenWidth*0.1), (screenWidth-(screenWidth*0.1)))
        end
        table.insert(enemies, skeleton)
        print("spawned")
    end
end


function enemy:move(dt)
    local playerX, playerY, playerWidth, playerHeight = player:returncoordinates()
    for i = #enemies, 1, -1 do
        local enemyL = enemies[i]
        if enemyL.x > playerX then
            enemyL.x = enemyL.x - enemyL.speed * dt
        elseif enemyL.x < playerX then
            enemyL.x = enemyL.x + enemyL.speed * dt
        end
        if enemyL.y > playerY then
            enemyL.y = enemyL.y - enemyL.speed * dt
        elseif enemyL.y < playerY then
            enemyL.y = enemyL.y + enemyL.speed * dt
        end
    end
end
]]--

function enemy:move(dt, map, enemyInfo)
    local targetX = math.floor(#map.grid[1] / 2) 
    local targetY = math.floor(#map.grid / 2) 
    
    for i = #enemies, 1, -1 do
        local enemyL = enemies[i]
        local gridX = math.floor(enemyL.x / tileSize) + 1
        local gridY = math.floor(enemyL.y / tileSize) + 1

        if not enemyL.path or #enemyL.path == 0 then
            enemyL.path = self:findPath(gridX, gridY, targetX, targetY, map)
        end

        if enemyL.path and #enemyL.path > 0 then
            local nextStep = enemyL.path[1] 
            local targetPixelX = (nextStep.x - 1) * tileSize
            local targetPixelY = (nextStep.y - 1) * tileSize

            local dx = targetPixelX - enemyL.x
            local dy = targetPixelY - enemyL.y
            local distance = math.sqrt(dx * dx + dy * dy)

            if distance > 0 then
                local moveX = (dx / distance) * enemyL.speed * dt
                local moveY = (dy / distance) * enemyL.speed * dt

                if math.abs(moveX) > math.abs(dx) then moveX = dx end
                if math.abs(moveY) > math.abs(dy) then moveY = dy end

                enemyL.x = enemyL.x + moveX
                enemyL.y = enemyL.y + moveY
            end

            if math.abs(dx) < 1 and math.abs(dy) < 1 then
                table.remove(enemyL.path, 1)
            end

            if checkCollision(tower.x, tower.y, tower.width, tower.height, enemyL.x, enemyL.y, enemyL.width, enemyL.height) then
                tower:takeDamage(5)
                table.remove(enemies, i)
            end
        end
    end

end


function enemy:findPath(startX, startY, targetX, targetY, map)
    local openSet = {{x = startX, y = startY, cost = 0, estimate = 0}}
    local cameFrom = {}
    local gScore = {}
    local fScore = {}

    local function key(x, y) return x .. "," .. y end
    local function heuristic(x1, y1, x2, y2)
        return math.abs(x1 - x2) + math.abs(y1 - y2)
    end

    gScore[key(startX, startY)] = 0
    fScore[key(startX, startY)] = heuristic(startX, startY, targetX, targetY)

    while #openSet > 0 do
        -- Find node with lowest fScore
        table.sort(openSet, function(a, b) return a.estimate < b.estimate end)
        local current = table.remove(openSet, 1)
        local cx, cy = current.x, current.y

        -- If target is reached
        if cx == targetX and cy == targetY then
            local path = {}
            while cameFrom[key(cx, cy)] do
                table.insert(path, 1, {x = cx, y = cy})
                cx, cy = cameFrom[key(cx, cy)].x, cameFrom[key(cx, cy)].y
            end
            return path
        end

        -- Check neighbors
        local directions = {
            {dx = -1, dy = 0}, -- Left
            {dx = 1, dy = 0},  -- Right
            {dx = 0, dy = -1}, -- Up
            {dx = 0, dy = 1},  -- Down
        }

        for _, dir in ipairs(directions) do
            local nx, ny = cx + dir.dx, cy + dir.dy
            if map.grid[ny] and map.grid[ny][nx] == 0 then
                local tentative_gScore = gScore[key(cx, cy)] + 1
                if tentative_gScore < (gScore[key(nx, ny)] or math.huge) then
                    cameFrom[key(nx, ny)] = {x = cx, y = cy}
                    gScore[key(nx, ny)] = tentative_gScore
                    fScore[key(nx, ny)] = tentative_gScore + heuristic(nx, ny, targetX, targetY)
                    table.insert(openSet, {x = nx, y = ny, cost = tentative_gScore, estimate = fScore[key(nx, ny)]})
                end
            end
        end
    end

    return nil
end


function enemy:update(dt, map)
    --enemy:spawn()
    enemy:move(dt, map, enemyInfo)

    enemy:collision()
    self.animation:update(dt)
end

function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
        x2 < x1 + w1 and
        y1 < y2 + h2 and
        y2 < y1 + h1
end


function enemy:collision()
    if not shoot.bullets or #shoot.bullets == 0 then return end

    for i = #enemies, 1, -1 do
        local skeleton = enemies[i]

        for j = #shoot.bullets, 1, -1 do
            local bullet = shoot.bullets[j]

            if checkCollision(bullet.x, bullet.y, 5, 5, skeleton.x, skeleton.y, skeleton.width, skeleton.height) then
                skeleton.health = skeleton.health - 1
                table.remove(shoot.bullets, j)

                if skeleton.health <= 0 then
                    table.remove(enemies, i)
                    --print("Enemy killed")
                else
                    --print("Enemy hit! Remaining health:", skeleton.health)
                end
                break
            end
        end
    end
end



function enemy:returnPosition()
    return self.x, self.y
end


function enemy:draw()
    for i, skeleton in ipairs(enemies) do
        self.animation:draw(skeleton.x, skeleton.y, self.width, self.height)
    end
end