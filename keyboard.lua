local keyboard = {}

function keyboard.pressKey(key)
   print("Key pressed: " .. key)
end

function love.keyreleased(key) --tipke released
   if key == 'b' then
      text = "The B key was released."
   elseif key == 'a' then
      a_down = false
   end
end

function love.keypressed(key) --tipke pressed
   if key == 'b' then
      text = "The B key was pressed."
   elseif key == 'a' then
      a_down = true
   end
end

return keyboard