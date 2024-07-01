btn = {}

function btn.update()
    btn.up = love.keyboard.isDown("w")
    btn.down = love.keyboard.isDown("s")
    btn.left = love.keyboard.isDown("a")
    btn.right = love.keyboard.isDown("d")
 
end

return btn