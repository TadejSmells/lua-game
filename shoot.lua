require("players")

shoot = {
    bullets = {},
    down = false
}

function shoot:load()
    self.down = false
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        shoot.down = true
        -- Use the first player (players[1]) for now. Change if needed.
        if players[1] then
            shoot:fire(players[1], x, y)
        end
    end
end

function shoot:fire(player, targetX, targetY)
    local playerX, playerY, playerWidth, playerHeight = player:returncoordinates()

    local bullet = {
        x = playerX + (playerWidth / 2),
        y = playerY + (playerHeight / 2),
        speed = 300
    }

    local directionX = targetX - bullet.x
    local directionY = targetY - bullet.y
    local length = math.sqrt(directionX^2 + directionY^2)

    bullet.dirX = directionX / length
    bullet.dirY = directionY / length

    table.insert(self.bullets, bullet)
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        shoot.down = false
    end
end

function shoot:update(dt)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    for i = #self.bullets, 1, -1 do
        local bullet = self.bullets[i]
        bullet.x = bullet.x + bullet.dirX * bullet.speed * dt
        bullet.y = bullet.y + bullet.dirY * bullet.speed * dt

        if bullet.x < 0 or bullet.x > screenWidth or bullet.y < 0 or bullet.y > screenHeight then
            table.remove(self.bullets, i)
        end
    end
end

function shoot:draw()
    for _, bullet in ipairs(self.bullets) do
        love.graphics.rectangle("fill", bullet.x, bullet.y, 5, 5)  -- Draw bullet
    end
end
