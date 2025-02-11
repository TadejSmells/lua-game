local sprite = require("sprite")
players = {}

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
        self.joystick = joystick  -- Store joystick object
        self.deadZone = 0.2  -- Dead zone to ignore small stick drift
        self.animation = sprite:changeFrames(42, 42, 6, spriteSheet)
    end

    function player:update(dt)
        self:move(dt)
        self:checkBoundaries()
        self.animation:update(dt)
    end

    function player:move(dt)
        local moveX, moveY = 0, 0

        -- Keyboard Controls
        if love.keyboard.isDown(self.controls.up) then moveY = moveY - 1 end
        if love.keyboard.isDown(self.controls.down) then moveY = moveY + 1 end
        if love.keyboard.isDown(self.controls.left) then moveX = moveX - 1 end
        if love.keyboard.isDown(self.controls.right) then moveX = moveX + 1 end

        -- Joystick Controls with Dead Zone Handling
        if self.joystick then
            local axisX = self.joystick:getAxis(1) -- Left Stick X
            local axisY = self.joystick:getAxis(2) -- Left Stick Y

            -- Apply dead zone
            if math.abs(axisX) > self.deadZone then
                moveX = moveX + axisX
            end
            if math.abs(axisY) > self.deadZone then
                moveY = moveY + axisY
            end
        end

        -- Normalize diagonal movement
        local length = math.sqrt(moveX * moveX + moveY * moveY)
        if length > 0 then
            moveX = (moveX / length) * self.speed * dt
            moveY = (moveY / length) * self.speed * dt
        end

        -- Apply movement
        self.x = self.x + moveX
        self.y = self.y + moveY
    end

    function player:checkBoundaries()
        if self.y < 0 then self.y = 0 end
        if self.y + self.height > ScreenHeight then self.y = ScreenHeight - self.height end
        if self.x < 0 then self.x = 0 end
        if self.x + self.width > ScreenWidth then self.x = ScreenWidth - self.width end
    end

    function player:returncoordinates()
        return self.x, self.y, self.width, self.height
    end

    function player:draw()
        self.animation:draw(self.x, self.y, self.width, self.height)
    end

    return player
end

function players:load()
    local joysticks = love.joystick.getJoysticks()

    local player1 = players:createPlayer(ScreenWidth / 4, ScreenHeight / 2, "slime_idle.png", 
        {up = "w", down = "s", left = "a", right = "d"}, joysticks[1]) -- Assign first controller
    player1:load()
    table.insert(players, player1)

    local player2 = players:createPlayer(ScreenWidth * 3 / 4, ScreenHeight / 2, "slime_idle.png", 
        {up = "up", down = "down", left = "left", right = "right"}, joysticks[2]) -- Assign second controller
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
