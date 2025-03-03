local sprite = require("sprite")
players = {}

-- Tower types
local towerTypes = {"basic", "rapid", "sniper"}

function players:createPlayer(x, y, spriteSheet, controls, joystick)
    local player = {}

    function player:load()
        love.graphics.setDefaultFilter("nearest", "nearest")
        self.x = x
        self.y = y
        self.height = spriteHeight
        self.width = spriteWidth
        self.speed = 500
        self.controls = controls
        self.joystick = joystick
        self.deadZone = 0.2
        self.buildPressed = false
        self.cooldownTime = 0.5
        self.shootCooldownTimer = 0
        self.animation = sprite:changeFrames(42, 42, 6, spriteSheet)
        
        self.currentTowerType = 1
        self.changeTowerType = false
    end

    function player:update(dt)
        self:move(dt)
        self:checkBoundaries()
        self:handleBuilding()

        if self.shootCooldownTimer > 0 then
            self.shootCooldownTimer = self.shootCooldownTimer - dt
        end
    
        if self.joystick then
            local r2Value = self.joystick:getAxis(6)  -- Right trigger
            local rightX = self.joystick:getAxis(3)   -- Right stick X-axis
            local rightY = self.joystick:getAxis(4)   -- Right stick Y-axis
    
            if r2Value > 0.5 and (math.abs(rightX) > self.deadZone or math.abs(rightY) > self.deadZone) then
                if self.shootCooldownTimer <= 0 then
                    shoot:fire(self, rightX, rightY)
                    self.shootCooldownTimer = self.cooldownTime  -- Reset cooldown
                end
            end
        end

        if self.changeTowerType then
            self:cycleTowerType()
            self.changeTowerType = false
        end

        self.animation:update(dt)
    end

    function player:move(dt)
        local moveX, moveY = 0, 0
    
        if self.controls then
            if love.keyboard.isDown(self.controls.up) then moveY = moveY - 1 end
            if love.keyboard.isDown(self.controls.down) then moveY = moveY + 1 end
            if love.keyboard.isDown(self.controls.left) then moveX = moveX - 1 end
            if love.keyboard.isDown(self.controls.right) then moveX = moveX + 1 end
        elseif self.joystick then
            local axisX = self.joystick:getAxis(1)
            local axisY = self.joystick:getAxis(2)
            
            if math.abs(axisX) > self.deadZone then moveX = moveX + axisX end
            if math.abs(axisY) > self.deadZone then moveY = moveY + axisY end
        end
        
        local length = math.sqrt(moveX * moveX + moveY * moveY)
        if length > 0 then
            moveX = (moveX / length) * self.speed * dt
            moveY = (moveY / length) * self.speed * dt
        end
        
        self.x = self.x + moveX
        self.y = self.y + moveY
    end
    

    function player:checkBoundaries()
        if self.y < 0 then self.y = 0 end
        if self.y + self.height > ScreenHeight then self.y = ScreenHeight - self.height end
        if self.x < 0 then self.x = 0 end
        if self.x + self.width > ScreenWidth then self.x = ScreenWidth - self.width end
    end
    
    function player:handleBuilding()
        if self.buildPressed then
            attackTowers:spawn(self.x, self.y, towerTypes[self.currentTowerType])  
            self.buildPressed = false
        end
    end

    function player:draw()
        self.animation:draw(self.x, self.y, self.width, self.height)
    end

    function player:cycleTowerType()
        self.currentTowerType = self.currentTowerType + 1
        if self.currentTowerType > #towerTypes then
            self.currentTowerType = 1  -- Reset to first tower type
        end
    end

    return player
end

function players:reload()
    for i = #players, 1, -1 do
        table.remove(players, i)
    end

    self:load()
end

function players:setTowerTypeForPlayer(player, towerType)
    attackTowers:setTowerType(towerType)
end

function players:load()
    local joysticks = love.joystick.getJoysticks()
    local p1Joystick, p2Joystick = nil, nil
    local p1Controls, p2Controls

    local keyboardControls = {
        up = "w",
        down = "s",
        left = "a",
        right = "d",
        build = "h",
        changeTowerType = "j"  -- Button for changing tower type on keyboard
    }

    if settings.player1Control == "controller" and #joysticks > 0 then
        p1Joystick = joysticks[1]
        p1Controls = nil
    else
        p1Controls = keyboardControls
        p1Joystick = nil
    end

    if settings.player2Control == "controller" and #joysticks > 0 then
        if p1Joystick == nil then
            p2Joystick = joysticks[1]
        elseif #joysticks > 1 then
            p2Joystick = joysticks[2]
        end
        p2Controls = nil 
    else
        p2Controls = keyboardControls
        p2Joystick = nil
    end

    local player1 = players:createPlayer(ScreenWidth / 4, ScreenHeight / 2, "slime_idle.png",
        p1Controls, p1Joystick)
    player1:load()
    table.insert(players, player1)

    local player2 = players:createPlayer(ScreenWidth * 3 / 4, ScreenHeight / 2, "slime_idle.png",
        p2Controls, p2Joystick)
    player2:load()
    table.insert(players, player2)
end

function players:update(dt)
    for _, player in ipairs(players) do
        player:update(dt)
    end
end

function players:draw()
    for _, player in ipairs(players) do
        player:draw()
    end

    local player1 = players[1]
    love.graphics.setColor(1, 1, 1)  -- White color for text
    love.graphics.print("Player 1 Tower: " .. towerTypes[player1.currentTowerType], 10, ScreenHeight - 30)

    local player2 = players[2]
    love.graphics.setColor(1, 1, 1)  -- White color for text
    love.graphics.print("Player 2 Tower: " .. towerTypes[player2.currentTowerType], ScreenWidth - 200, ScreenHeight - 30)

end

function love.joystickpressed(joystick, button)
    for _, player in ipairs(players) do
        if player.joystick == joystick and (button == "a" or button == 1) then
            player.buildPressed = true
        end
        if player.joystick == joystick and (button == "y" or button == 4) then
            player.changeTowerType = true
        end
    end
end

