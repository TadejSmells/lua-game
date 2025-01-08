--love.window.setFullscreen(true, "exclusive")
--love.window.setMode(1280, 720, {fullscreen = false})
love.window.setMode(1920, 1080, {fullscreen = false})


ScreenWidth, ScreenHeight = love.graphics.getDimensions()


local renderScreenWidth = 1280
local renderScreenHeight = 720
baseTileSize = 32
local baseSpriteHeight = 42
local baseSpriteWidth = 42

ratio = ScreenWidth / ScreenHeight

tileSize = math.floor(baseTileSize * ratio)

print(ratio)

spriteHeight = math.floor(baseSpriteHeight * ratio)
spriteWidth = math.floor(baseSpriteWidth * ratio)