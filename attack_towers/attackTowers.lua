attackTowers = {}
local sprite = require("sprite")
local shoot = require("shoot")

function attackTowers:load()
    self.originalWidth = 338
    self.originalHeight = 545

    local scaleX = ratio - 0.9
    local scaleY = ratio - 0.9

    self.width = self.originalWidth * scaleX
    self.height = self.originalHeight * scaleY
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    self.animation = sprite:changeFrames(self.originalWidth, self.originalHeight, 1, "aseprite/tower1.png")

    self.x = 200
    self.y = 200
    self.radius = 200 -- Attack range
    self.fireRate = 1 -- Seconds per shot
    self.timeSinceLastShot = 0
    self.bullets = {}
end

function attackTowers:update(dt)
    self.animation:update(dt)
    self.timeSinceLastShot = self.timeSinceLastShot + dt

    -- Shoot if cooldown is ready
    if self.timeSinceLastShot >= self.fireRate then
        local target = self:findTarget()
        if target then
            self:shootBullet(target)
            self.timeSinceLastShot = 0
        end
    end

    -- Update bullets
    for i = #self.bullets, 1, -1 do
        local bullet = self.bullets[i]
        bullet.x = bullet.x + bullet.dx * dt
        bullet.y = bullet.y + bullet.dy * dt

        -- Check for collision with target
        if math.abs(bullet.x - bullet.target.x) < 5 and math.abs(bullet.y - bullet.target.y) < 5 then
            bullet.target.health = bullet.target.health - 1
            if bullet.target.health <= 0 then
                for j = #enemies, 1, -1 do
                    if enemies[j] == bullet.target then
                        table.remove(enemies, j)
                        break
                    end
                end
            end
            table.remove(self.bullets, i)
        end
    end
end

function attackTowers:draw()
    local scaleX = ratio - 0.9
    local scaleY = ratio - 0.9

    love.graphics.draw(
        self.animation.spriteSheet,
        self.animation.frames[self.animation.currentFrame],
        self.x, self.y,
        0,
        scaleX, scaleY
    )

    -- Draw bullets
    for _, bullet in ipairs(self.bullets) do
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("fill", bullet.x, bullet.y, 5)
        love.graphics.setColor(1, 1, 1)
    end
end

function attackTowers:findTarget()
    local closestEnemy = nil
    local closestDistance = self.radius
    
    for _, enemy in ipairs(enemies) do
        local distance = math.sqrt((enemy.x - (self.x + self.width / 2))^2 + (enemy.y - (self.y + self.height / 2))^2)
        if distance <= self.radius and (not closestEnemy or distance < closestDistance) then
            closestEnemy = enemy
            closestDistance = distance
        end
    end
    return closestEnemy
end

function attackTowers:shootBullet(target)
    local bullet = {
        x = self.x + self.width / 2,
        y = self.y,
        target = target,
        speed = 300
    }
    
    local dx = target.x - bullet.x
    local dy = target.y - bullet.y
    local distance = math.sqrt(dx * dx + dy * dy)
    
    bullet.dx = (dx / distance) * bullet.speed
    bullet.dy = (dy / distance) * bullet.speed
    
    table.insert(self.bullets, bullet)
end
