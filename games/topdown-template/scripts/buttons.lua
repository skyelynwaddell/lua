btn = {}

function btn.update()
    btn.up = love.keyboard.isDown("w")
    btn.down = love.keyboard.isDown("s")
    btn.left = love.keyboard.isDown("a")
    btn.right = love.keyboard.isDown("d")

    btn.a = love.keyboard.isDown("z")
    btn.b = love.keyboard.isDown("x")

    btn.start = love.keyboard.isDown("return")
    btn.select = love.keyboard.isDown("rshift")
end

return btn