towerBullet = {}
sprite = require("sprite")

function towerBullet:load()
    self.x = 200
    self.y = 200
    self.radius = 200 -- Attack range
    self.fireRate = 1 -- Seconds per shot
    self.timeSinceLastShot = 0
    self.width = 48
    self.height = 28
    self.animation = sprite:changeFrames(self.width, self.height, 2, "aseprite/bullet.png")
end

function towerBullet:update(dt)
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
    for i = #shoot.bullets, 1, -1 do
        local bullet = shoot.bullets[i]
        
        -- Update direction dynamically
        local dx = bullet.target.x + (bullet.target.width / 2) - bullet.x
        local dy = bullet.target.y + (bullet.target.height / 2) - bullet.y
        local distance = math.sqrt(dx * dx + dy * dy)
        bullet.angle = math.atan2(bullet.dy, bullet.dx)
        
        if distance > 0 then
            bullet.dx = (dx / distance) * bullet.speed
            bullet.dy = (dy / distance) * bullet.speed
        end
        
        bullet.x = bullet.x + bullet.dx * dt
        bullet.y = bullet.y + bullet.dy * dt

        -- Check for collision with target
    end
end

function towerBullet:draw()
    -- Draw bullets
    local scaleX = ratio - 0.6
    local scaleY = ratio - 0.6
    for _, bullet in ipairs(shoot.bullets) do
        love.graphics.draw(
            self.animation.spriteSheet,
            self.animation.frames[self.animation.currentFrame],
            bullet.x, bullet.y,
            bullet.angle,
            scaleX, scaleY,
            self.width / 2, self.height / 2 
        )
    end
end

function towerBullet:findTarget()
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

function towerBullet:shootBullet(target)
    local bullet = {
        x = self.x + self.width / 2,
        y = self.y,
        target = target,
        speed = 300,
        dx = 0,
        dy = 0,
        source = "tower"
    }
    
    table.insert(shoot.bullets, bullet)
end