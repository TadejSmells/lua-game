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
    if gameState == "playing" then
        for _, player in ipairs(players) do
            if player.controls then
                if player == players[1] and settings.player1Control == "keyboard" or 
                    player == players[2] and settings.player2Control == "keyboard" then
                    if button == 1 and shoot.cooldownTimer <= 0 then
                        shoot.down = true
                        shoot:fire(player, x, y)
                        shoot.cooldownTimer = shoot.cooldownTime
                    end
                end
            end
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if gameState == "playing" then
        if button == 1 then
            shoot.down = false
        end
    end
end

function shoot:fire(player, directionX, directionY)
    if not player then return end

    local playerX = player.x + (player.width / 2)
    local playerY = player.y + (player.height / 2)

    if player.controls then
        directionX = directionX - playerX
        directionY = directionY - playerY
    end

    local length = math.sqrt(directionX^2 + directionY^2)
    if length == 0 then return end

    directionX = directionX / length
    directionY = directionY / length

    local bullet = {
        x = playerX,
        y = playerY,
        speed = 300,
        damage = 1,
        dirX = directionX,
        dirY = directionY,
        angle = math.atan2(directionY, directionX),
        source = "player"
    }

    table.insert(self.bullets, bullet)
end

function shoot:update(dt)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    if self.cooldownTimer > 0 then
        self.cooldownTimer = self.cooldownTimer - dt
    end

    for i = #self.bullets, 1, -1 do
        local bullet = self.bullets[i]
        if bullet.source == "player" then
            bullet.x = bullet.x + bullet.dirX * bullet.speed * dt
            bullet.y = bullet.y + bullet.dirY * bullet.speed * dt

            if bullet.x < 0 or bullet.x > screenWidth or bullet.y < 0 or bullet.y > screenHeight then
                table.remove(self.bullets, i)
            end
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
