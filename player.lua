player = {}

function player:load()
    position_of_player_in_room = 1
    self.x = ScreenWidth / 2
    self.y = ScreenHeight / 2
    self.height = 50
    self.width = 50
    self.speed = 500

    player:framesLoad("slime_idle.png")
end

function player:framesLoad(imagePath)
    self.spriteSheet = love.graphics.newImage(imagePath)
    
    self.frameWidth = 64
    self.frameHeight = 64
    self.totalFrames = 6

    self.frames = {}
    for i = 0, self.totalFrames - 1 do
        self.frames[i + 1] = love.graphics.newQuad(
            i * self.frameWidth, 0, 
            self.frameWidth, self.frameHeight, 
            self.spriteSheet:getWidth(), self.spriteSheet:getHeight()
        )
    end

    self.currentFrame = 1
    self.frameDuration = 0.1  -- Time between frames
    self.timePassed = 0
end

function player:update(dt)
    player:move(dt)
    player:checkBoundaries()
    player:updateAnimation(dt)
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

function player:updateAnimation(dt)
    -- Update the frame based on the time passed
    self.timePassed = self.timePassed + dt
    if self.timePassed >= self.frameDuration then
        self.timePassed = 0
        self.currentFrame = self.currentFrame + 1
        if self.currentFrame > self.totalFrames then
            self.currentFrame = 1
        end
    end
end

function player:returncoordinates()
    return self.x, self.y, self.width, self.height
end


function player:draw()
    -- Draw the current frame of the player
    love.graphics.draw(self.spriteSheet, self.frames[self.currentFrame], self.x, self.y, 0, self.width / self.frameWidth, self.height / self.frameHeight)
end
