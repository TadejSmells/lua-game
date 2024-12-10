local sprite = require("sprite")
player = {}

function player:load()
    position_of_player_in_room = 1
    self.x = ScreenWidth / 2
    self.y = ScreenHeight / 2
    self.height = 64
    self.width = 64
    self.speed = 500

    self.animation = sprite:changeFrames(64, 64, 6, "slime_idle.png")
end

function player:update(dt)
    player:move(dt)
    player:checkBoundaries()
    self.animation:update(dt)
end

function player:move(dt)
    if love.keyboard.isDown("w") then
        self.y = self.y - self.speed * dt
    end
    if love.keyboard.isDown("s") then
        self.y = self.y + self.speed * dt
    end
    if love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown("d") then
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
        self.x = ScreenWidth - self.width
    end
end

function player:returncoordinates()
    return self.x, self.y, self.width, self.height
end

function player:draw()
    self.animation:draw(self.x, self.y, self.width, self.height)
end
