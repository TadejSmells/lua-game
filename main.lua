
require("players")
require("tower")
require("enemy")
require("map.loadmap")
require("variables")
require("starting-screen.menu")
require("starting-screen.settings")
--require("shoot")


function love.load()
    menu:load()
    settings:load()
    players:load()
    tower:load()
    enemy:load()
    loadmap:load()
    --shoot:load()
end

function love.update(dt)
    if gameState == "menu" then
        menu:update(dt)
    elseif gameState == "settings" then
        settings:update(dt)
    elseif gameState == "playing" then
        players:update(dt)
        tower:update()
        enemy:update(dt)
        loadmap:update(dt)
        --shoot:update(dt)
    end
end

function love.draw()
    if gameState == "menu" then
        menu:draw()
    elseif gameState == "settings" then
        settings:draw()
    elseif gameState == "playing" then
        loadmap:draw()
        tower:draw()
        enemy:draw()
        --shoot:draw()
        players:draw()
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
                --activeKeybinds = {} -- No specific keybinds for playing -- TODO: 
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
    end
end