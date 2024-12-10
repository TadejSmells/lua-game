require("player")
shoot = {}
bullets = {}

-- Load the shooter
function shoot:load()
    self.down = false
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        shoot.down = true
        shoot:fire(x, y)
    end
end

function shoot:fire(targetX, targetY)
    local playerX, playerY, playerWidth, playerHeight = player:returncoordinates()
    
    -- Ustvari metek ki gre proti miški
    local bullet = {}
    bullet.x = playerX + (playerWidth / 2)
    bullet.y = playerY + (playerHeight / 2)
    
    -- izračunaj smer metka
    local directionX = targetX - bullet.x
    local directionY = targetY - bullet.y
    local length = math.sqrt(directionX^2 + directionY^2)

    bullet.dirX = directionX / length
    bullet.dirY = directionY / length
    
    bullet.speed = 300  -- Bullet speed
    table.insert(bullets, bullet)  -- Store the bullet in the bullets table
end

-- When the mouse is released, stop firing (if needed)
function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        shoot.down = false
    end
end

function shoot:update(dt)
    -- Screen dimensions
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Iterate through bullets in reverse to remove off-screen or collided bullets
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        
        -- Update bullet position
        bullet.x = bullet.x + bullet.dirX * bullet.speed * dt
        bullet.y = bullet.y + bullet.dirY * bullet.speed * dt
        
        -- Remove bullet if it goes off the screen
        if bullet.x < 0 or bullet.x > screenWidth or bullet.y < 0 or bullet.y > screenHeight then
            table.remove(bullets, i)
        end
    end
end

-- Draw the bullets
function shoot:draw()
    for i, bullet in ipairs(bullets) do
        love.graphics.rectangle("fill", bullet.x, bullet.y, 5, 5)  -- Draw the bullet
    end
end
