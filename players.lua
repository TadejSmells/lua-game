local sprite = require("sprite")
players = {}


function players:createPlayer(x, y, spriteSheet, controls)
    local player = {}

    function player:load()
        love.graphics.setDefaultFilter("nearest", "nearest")
        position_of_player_in_room = 1
        self.x = ScreenWidth / 2
        self.y = ScreenHeight / 2
        self.height = spriteHeight
        self.width = spriteWidth
        
        self.speed = 500
        self.controls = controls
        self.animation = sprite:changeFrames(42, 42, 6, spriteSheet)
    end

    function player:update(dt)
        player:move(dt)
        player:checkBoundaries()
        self.animation:update(dt)
    end

    function player:move(dt)
        if love.keyboard.isDown(self.controls.up) then
            self.y = self.y - self.speed * dt
        end
        if love.keyboard.isDown(self.controls.down) then
            self.y = self.y + self.speed * dt
        end
        if love.keyboard.isDown(self.controls.left) then
            self.x = self.x - self.speed * dt
        end
        if love.keyboard.isDown(self.controls.right) then
            self.x = self.x + self.speed * dt
        end
    end

    function player:checkBoundaries()
        if self.y < 0 then 
            self.y = 0 
        elseif self.y + self.height > ScreenHeight then
            self.y = ScreenHeight - self.height 
        end

        if self.x < 0 then
            self.x = 0 
        elseif self.x + self.width > ScreenWidth then
            print(self.x + self.width)
            print(ScreenWidth)
            self.x = ScreenWidth - self.width
        end
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
    local player1 = players:createPlayer(ScreenWidth / 4, ScreenHeight / 2, "slime_idle.png", {up = "w", down = "s", left = "a", right = "d"})
    player1:load()
    table.insert(players, player1)

    local player2 = players:createPlayer(ScreenWidth * 3 / 4, ScreenHeight / 2, "slime_idle.png", {up = "up", down = "down", left = "left", right = "right"})
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
