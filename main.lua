require("player")
require("tower")
require("enemy")
require("shoot")

ScreenHeight = love.graphics.getHeight()
ScreenWidth = love.graphics.getWidth()

function love.load()
  player:load()
  tower:load()
  enemy:load()
  shoot:load()
end


function love.update(dt)
  player:update(dt)
  tower:update()
  enemy:update(dt)
  shoot:update(dt)
end


function love.draw() 
  tower:draw()
  enemy:draw()
  shoot:draw()
  player:draw()
end