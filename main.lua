
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
    print("menu")
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
