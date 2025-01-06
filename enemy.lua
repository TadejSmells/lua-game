local sprite = require("sprite")
enemy = {}
enemies = {}

function enemy:load()
    self.height = 64
    self.width = 64
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    self.animation = sprite:changeFrames(self.height, self.width, 1, "enemy.png")
end

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

--[[
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

function enemy:update(dt)
    enemy:spawn()
    --enemy:move(dt)
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
    for i = #enemies, 1, -1 do
        local skeleton = enemies[i]
        
        for j = #bullets, 1, -1 do
            local bullet = bullets[j]
            
            if checkCollision(bullet.x, bullet.y, 5, 5, skeleton.x, skeleton.y, self.width, self.height) then
                skeleton.health = skeleton.health - 1
                table.remove(bullets, j)

                if skeleton.health <= 0 then
                    table.remove(enemies, i)
                    print("Enemy killed")
                else
                    print("Enemy hit! Remaining health:", skeleton.health)
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