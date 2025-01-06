require("players")
require("tower")
require("enemy")
--require("shoot")

ScreenHeight = love.graphics.getHeight()
ScreenWidth = love.graphics.getWidth()

function love.load()
  players:load()
  tower:load()
  enemy:load()
  --shoot:load()
end


function love.update(dt)
  players:update(dt)
  tower:update()
  enemy:update(dt)
  --shoot:update(dt)
end


function love.draw() 
  tower:draw()
  enemy:draw()
  --shoot:draw()
  players:draw()
end