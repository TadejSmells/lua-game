--love.window.setFullscreen(true, "exclusive")
love.window.setMode(1280, 720, {fullscreen = false})
--love.window.setMode(1024,576, {fullscreen = false})

keybinds = {
    menu = {
        up = "up",
        down = "down",
        select = "return"
    },
    settings = {
        back = "return"
    },

    pauseMenu = {
        up = "up",
        down = "down",
        select = "return",
        pause = "escape"
    }
}

activeKeybinds = keybinds.menu
gameState = "menu"



ScreenWidth, ScreenHeight = love.graphics.getDimensions()


local renderScreenWidth = 1280
local renderScreenHeight = 720
baseTileSize = 32
local baseSpriteHeight = 42
local baseSpriteWidth = 42
chosenMap = 1
isPaused = false

ratio = math.max(math.min(ScreenWidth / renderScreenWidth, ScreenHeight / renderScreenHeight), 0.5)

print(ratio)

spriteHeight = math.floor(baseSpriteHeight * ratio)
spriteWidth = math.floor(baseSpriteWidth * ratio)