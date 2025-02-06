require("players")
local sprite = require("sprite")

shoot = {
    bullets = {},
    down = false,
    cooldownTime = 0.5,
    cooldownTimer = 0
}

function shoot:load()
    self.down = false
    self.originalWidth = 48
    self.originalHeight = 28
    self.animation = sprite:changeFrames(self.originalWidth, self.originalHeight, 2, "aseprite/bullet.png")
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 and shoot.cooldownTimer <= 0 then
        shoot.down = true
        if players[1] then
            shoot:fire(players[1], x, y)
            shoot.cooldownTimer = shoot.cooldownTime
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
    bullet.angle = math.atan2(bullet.dirY, bullet.dirX)

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

    if self.cooldownTimer > 0 then
        self.cooldownTimer = self.cooldownTimer - dt
    end

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
    local scaleX = ratio - 0.6
    local scaleY = ratio - 0.6
    for _, bullet in ipairs(self.bullets) do
        love.graphics.draw(
            self.animation.spriteSheet,
            self.animation.frames[self.animation.currentFrame],
            bullet.x, bullet.y,
            bullet.angle,
            scaleX, scaleY,
            self.originalWidth / 2, self.originalHeight / 2 
        )
    end
end
