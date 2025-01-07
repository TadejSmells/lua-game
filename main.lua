require("players")
require("tower")
require("enemy")
require("map.loadmap")
require("variables")
--require("shoot")


function love.load()
  players:load()
  tower:load()
  enemy:load()
  loadmap:load()
  --shoot:load()
end


function love.update(dt)
  players:update(dt)
  tower:update()
  enemy:update(dt)
  loadmap:update(dt)
  --shoot:update(dt)
end


function love.draw()
  loadmap:draw()
  tower:draw()
  enemy:draw()
  --shoot:draw()
  players:draw()
  
end