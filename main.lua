
require("players")
require("tower")
require("enemy")
require("map.loadmap")
require("variables")
require("starting-screen.menu")
require("starting-screen.settings")
require("pauseMenu")
require("map.map")
require("shoot")


function love.load()
    menu:load()
    settings:load()
    loadmap:load()
    players:load()
    tower:load()
    enemy:load()
    pauseMenu:load()
    shoot:load()
end

function love.update(dt)
    if gameState == "menu" then
        menu:update(dt)
    elseif gameState == "settings" then
        settings:update(dt)
    elseif gameState == "playing" then
        if not isPaused then 
            players:update(dt)
            tower:update(dt)
            enemy:update(dt, map, enemyType)
            loadmap:update(dt)
            shoot:update(dt)
        end
    end
end

function love.draw()
    if gameState == "menu" then
        menu:draw()
    elseif gameState == "settings" then
        settings:draw()
    elseif gameState == "playing" then
        if not isPaused then 
            loadmap:draw()
            tower:draw()
            enemy:draw()
            shoot:draw()
            players:draw()
        else
            loadmap:draw()
            enemy:draw()
            players:draw()
            pauseMenu:draw()
        end
    end
end


function love.keypressed(key, scancode, isrepeat)
    if gameState == "menu" then
        if key == activeKeybinds.up then
            print("menu up")
            menu.selected = menu.selected - 1
            if menu.selected < 1 then menu.selected = #menu.options end
        elseif key == activeKeybinds.down then
            menu.selected = menu.selected + 1
            if menu.selected > #menu.options then menu.selected = 1 end
        elseif key == activeKeybinds.select then
            if menu.selected == 1 then
                gameState = "playing"              
            elseif menu.selected == 2 then
                gameState = "settings"
                activeKeybinds = keybinds.settings
            elseif menu.selected == 3 then
                love.event.quit()
            end
        end
    elseif gameState == "settings" then
        if key == activeKeybinds.back then
            gameState = "menu"
            activeKeybinds = keybinds.menu
        end
    elseif gameState == "playing" and not isPaused then
        if key == keybinds.pauseMenu.pause then
            isPaused = not isPaused
            activeKeybinds = keybinds.pauseMenu
        end
    end
    if isPaused then
        if key == activeKeybinds.up then
            pauseMenu.selected = pauseMenu.selected - 1
            if pauseMenu.selected < 1 then pauseMenu.selected = #pauseMenu.options end
        elseif key == activeKeybinds.down then
            pauseMenu.selected = pauseMenu.selected + 1
            if pauseMenu.selected > #pauseMenu.options then pauseMenu.selected = 1 end
        elseif key == activeKeybinds.select then
            if pauseMenu.selected == 1 then
                isPaused = false
            elseif pauseMenu.selected == 2 then
                
            elseif pauseMenu.selected == 3 then
                gameState = "menu"
                isPaused = false
                activeKeybinds = keybinds.menu
            end
        end
    end
end