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
require("attack_towers.attackTowers")
require("attack_towers.attackTowersUpgrades")


function love.load()
    menu:load()
    settings:load()
    loadmap:load()
    players:load()
    tower:load()
    enemy:load()
    pauseMenu:load()
    shoot:load()
    attackTowers:load()
    attackTowersUpgrades:load()
    treeImage = love.graphics.newImage("map/map-layouts/tree.png")
    shadowImage = love.graphics.newImage("map/map-layouts/treeShadow.png")
end

function love.update(dt)
    if gameState == "menu" then
        menu:update(dt)
    elseif gameState == "settings" then
        --settings:update(dt)
    elseif gameState == "playing" then
        if not isPaused then
            players:update(dt)
            tower:update(dt)
            enemy:update(dt, map)
            loadmap:update(dt)
            shoot:update(dt)
            attackTowers:update(dt)
        end
    end
end

function love.draw()
    if gameState == "menu" then
        menu:draw()
    elseif gameState == "settings" then
        settings:draw()
    elseif gameState == "playing" then
        loadmap:draw()
        attackTowers:draw()
        tower:draw()
        enemy:draw()
        love.graphics.draw(shadowImage, 100, 100)
        love.graphics.draw(treeImage, 116, 63)
        shoot:draw()
        players:draw()
        attackTowersUpgrades:draw()
        

        if isPaused then 
            pauseMenu:draw()
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if gameState == "menu" then
        if key == activeKeybinds.up then
            menu.selected = menu.selected - 1
            if menu.selected < 1 then menu.selected = #menu.options end
        elseif key == activeKeybinds.down then
            menu.selected = menu.selected + 1
            if menu.selected > #menu.options then menu.selected = 1 end
        elseif key == activeKeybinds.select then
            if menu.selected == 1 then
                gameState = "playing"
                activeKeybinds = keybinds.pauseMenu
            elseif menu.selected == 2 then
                gameState = "settings"
                activeKeybinds = keybinds.settings
            elseif menu.selected == 3 then
                love.event.quit()
            end
        end
    elseif gameState == "settings" then
        if key == activeKeybinds.up then
            settings.selected = settings.selected - 1
            if settings.selected < 1 then settings.selected = #settings.options end
        elseif key == activeKeybinds.down then
            settings.selected = settings.selected + 1
            if settings.selected > #settings.options then settings.selected = 1 end
        elseif key == activeKeybinds.select then
            if settings.selected == 1 then
                gameState = "menu"
                activeKeybinds = keybinds.menu
            elseif settings.selected == 2 then  
                if settings.player1Control == "keyboard" then
                    settings.player1Control = "controller"
                else
                    if settings.player2Control == "keyboard" then
                        settings.player2Control = "controller"
                    end
                    settings.player1Control = "keyboard"
                end
            elseif settings.selected == 3 then
                if settings.player2Control == "keyboard" then
                    settings.player2Control = "controller"
                else
                    if settings.player1Control == "keyboard" then
                        settings.player1Control = "controller"
                    end
                    settings.player2Control = "keyboard"
                end
            end
            settings.options[2] = "Player 1: " .. settings.player1Control:sub(1,1):upper() .. settings.player1Control:sub(2)
            settings.options[3] = "Player 2: " .. settings.player2Control:sub(1,1):upper() .. settings.player2Control:sub(2)
            players:reload()
        end    
    elseif gameState == "playing" and not isPaused then
        if key == activeKeybinds.pause then
            isPaused = not isPaused
            activeKeybinds = keybinds.pauseMenu
        end
        for _, player in ipairs(players) do
            if player.controls then
                if  key == player.controls.build then
                    player.buildPressed = true
                elseif key == player.controls.changeTowerType then
                    player.changeTowerType = true
                elseif key == player.controls.upgrade then
                    player.upgradePressed = true
                end
                if attackTowersUpgrades.inRange then
                    if key == player.controls.upgradeUp then
                        attackTowersUpgrades:upgrade("speed")
                    elseif key == player.controls.upgradeRight then
                        attackTowersUpgrades:upgrade("fireRate")
                    elseif key == player.controls.upgradeDown then
                        attackTowersUpgrades:upgrade("damage")
                    elseif key == player.controls.upgradeLeft then
                        attackTowersUpgrades:upgrade("range")
                    end
                end
            end
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
                activeKeybinds = keybinds.pauseMenu
            elseif pauseMenu.selected == 2 then
                -- Handle other pause menu options
            elseif pauseMenu.selected == 3 then
                gameState = "menu"
                isPaused = false
                activeKeybinds = keybinds.menu
            end
        end
    end
end
