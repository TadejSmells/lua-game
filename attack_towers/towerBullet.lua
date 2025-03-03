towerBullet = {}
sprite = require("sprite")

towerBullet.towers = {} -- Store multiple towers with their bullet properties

function towerBullet:spawn(tower)
    tower.originalWidth = 48
    tower.originalHeight = 28
    table.insert(self.towers, tower)
end

function towerBullet:update(dt)
    for _, tower in ipairs(self.towers) do
        tower.timeSinceLastShot = tower.timeSinceLastShot + dt

        if tower.timeSinceLastShot >= tower.fireRate then
            local target = self:findTarget(tower)
            if target then
                self:shootBullet(tower, target)
                tower.timeSinceLastShot = 0
            end
        end
    end

    for i = #shoot.bullets, 1, -1 do
        local bullet = shoot.bullets[i]
    
        if bullet.source == "tower" then
            local targetExists = false
            for _, enemy in ipairs(enemies) do
                if enemy == bullet.target then
                    targetExists = true
                    break
                end
            end

            if not targetExists then
                table.remove(shoot.bullets, i)
            else
                local dx = bullet.target.x + (bullet.target.width / 2) - bullet.x
                local dy = bullet.target.y + (bullet.target.height / 2) - bullet.y
                local distance = math.sqrt(dx * dx + dy * dy)
                bullet.angle = math.atan2(dy, dx)
                
                if distance > 0 then
                    bullet.dx = (dx / distance) * bullet.speed
                    bullet.dy = (dy / distance) * bullet.speed
                end
                
                bullet.x = bullet.x + bullet.dx * dt
                bullet.y = bullet.y + bullet.dy * dt
    
                -- Check max travel distance
                if bullet.startX and bullet.startY then
                    local traveled = math.sqrt((bullet.x - bullet.startX)^2 + (bullet.y - bullet.startY)^2)
                    if traveled > 200 then  
                        table.remove(shoot.bullets, i)
                    end
                end
            end
        end
    end
    
end

function towerBullet:findTarget(tower)
    local closestEnemy = nil
    local closestDistance = tower.radius
    
    for _, enemy in ipairs(enemies) do
        local distance = math.sqrt((enemy.x - (tower.x + tower.originalWidth / 2))^2 + (enemy.y - (tower.y + tower.originalHeight / 2))^2)
        if distance <= tower.radius and (not closestEnemy or distance < closestDistance) then
            closestEnemy = enemy
            closestDistance = distance
        end
    end
    return closestEnemy
end

function towerBullet:shootBullet(tower, target)
    local bullet = {
        x = tower.x + tower.originalWidth / 2,
        y = tower.y,
        target = target,
        damage = tower.damage,
        speed = 300,
        dx = 0,
        dy = 0,
        source = "tower"
    }
    
    table.insert(shoot.bullets, bullet)
end
