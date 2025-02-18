local sprite = require("sprite")
players = {}

towers = {} -- Table to store placed towers

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
        self.animation = sprite:changeFrames(42, 42, 6, spriteSheet)
    end

    function player:update(dt)
        self:move(dt)
        self:checkBoundaries()
        self:handleBuilding()
    
        if self.joystick then
            local r2Value = self.joystick:getAxis(6)
            local rightX = self.joystick:getAxis(3) 
            local rightY = self.joystick:getAxis(4)
            --print(rightX .. " " .. rightY)
            if r2Value > 0.5 and (math.abs(rightX) > self.deadZone or math.abs(rightY) > self.deadZone) then
                shoot:fire(self, rightX, rightY)
            end
        end
    
        self.animation:update(dt)
    end

    function player:move(dt)
        local moveX, moveY = 0, 0
        
        if love.keyboard.isDown(self.controls.up) then moveY = moveY - 1 end
        if love.keyboard.isDown(self.controls.down) then moveY = moveY + 1 end
        if love.keyboard.isDown(self.controls.left) then moveX = moveX - 1 end
        if love.keyboard.isDown(self.controls.right) then moveX = moveX + 1 end

        if self.joystick then
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
            attackTowers:spawn(self.x, self.y)
            self.buildPressed = false
        end
    end

    function player:draw()
        self.animation:draw(self.x, self.y, self.width, self.height)
    end

    return player
end

function players:load()
    local joysticks = love.joystick.getJoysticks()

    local player1 = players:createPlayer(ScreenWidth / 4, ScreenHeight / 2, "slime_idle.png", 
        {up = "w", down = "s", left = "a", right = "d", build = "h"}, joysticks[1])
    player1:load()
    table.insert(players, player1)

    local player2 = players:createPlayer(ScreenWidth * 3 / 4, ScreenHeight / 2, "slime_idle.png", 
        {up = "up", down = "down", left = "left", right = "right", build = "k"}, joysticks[2])
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
end

function love.joystickpressed(joystick, button)
    for _, player in ipairs(players) do
        if player.joystick == joystick and (button == "a" or button == 1) then
            player.buildPressed = true
        end
    end
end
