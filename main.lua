function love.load()
   font = love.graphics.setNewFont(300)
end

function love.draw()
   love.window.setMode(1920, 1080)
   love.graphics.setFont(font)
   love.graphics.print("BRB", 100, 100)
end
