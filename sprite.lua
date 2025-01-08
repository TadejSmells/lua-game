local sprite = {}

function sprite:changeFrames(frameWidth, frameHeight, totalFrames, imagePath)
    local animation = {}

    animation.spriteSheet = love.graphics.newImage(imagePath)
    animation.frameWidth = frameWidth
    animation.frameHeight = frameHeight
    animation.totalFrames = totalFrames

    animation.frames = {}
    for i = 0, totalFrames - 1 do
        animation.frames[i + 1] = love.graphics.newQuad(
            i * frameWidth, 0,
            frameWidth, frameHeight,
            animation.spriteSheet:getWidth(), animation.spriteSheet:getHeight()
        )
    end

    animation.currentFrame = 1
    animation.frameDuration = 0.1 -- Time between frames
    animation.timePassed = 0

    function animation:update(dt)
        self.timePassed = self.timePassed + dt
        if self.timePassed >= self.frameDuration then
            self.timePassed = self.timePassed - self.frameDuration
            self.currentFrame = self.currentFrame % self.totalFrames + 1
        end
    end

    function animation:draw(x, y, width, height)
        love.graphics.draw(
            self.spriteSheet,
            self.frames[self.currentFrame],
            x, y,
            0, 
            ratio, ratio -- ratio for hitbox draw
        )
    end

    return animation
end

return sprite