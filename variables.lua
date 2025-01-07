ScreenWidth, ScreenHeight = love.graphics.getDimensions() -- Initialize with default dimensions

function love.resize(w, h)
    ScreenWidth, ScreenHeight = w, h
    print("Window resized to:", ScreenWidth, ScreenHeight)
end

baseTileSize = 32
local baseSpriteHeight = 42
local baseSpriteWidth = 42

ratio = ScreenWidth / ScreenHeight

tileSize =math.floor(baseTileSize * ratio)

print(ratio)

spriteHeight = math.floor(baseSpriteHeight * ratio)
spriteWidth = math.floor(baseSpriteWidth * ratio)