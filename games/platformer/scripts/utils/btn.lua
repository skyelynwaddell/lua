local btn = {}
btn.p = {}

function btn:update()

    --btn down
    btn.up    = love.keyboard.isDown("w") or love.keyboard.isDown("up")
    btn.down  = love.keyboard.isDown("s") or love.keyboard.isDown("down")
    btn.left  = love.keyboard.isDown("a") or love.keyboard.isDown("left")
    btn.right = love.keyboard.isDown("d") or love.keyboard.isDown("right")

    btn.a = love.keyboard.isDown("space")
    btn.b = love.keyboard.isDown("z")
    btn.x = love.keyboard.isDown("x")
    btn.y = love.keyboard.isDown("c")

    btn.aim = love.keyboard.isDown("lshift")

    btn.start = love.keyboard.isDown("return")
    btn.select = love.keyboard.isDown("rshift")

    btn.esc = love.keyboard.isDown("escape")

    --btn pressed
    btn.p.up    = "w" or "up"
    btn.p.down  = "s" or "down"
    btn.p.left  = "a" or "left"
    btn.p.right = "d" or "right"

    btn.p.a = "space"
    btn.p.b = "z"
    btn.p.x = "x"
    btn.p.y = "c"

    btn.p.start = "return"
    btn.p.select = "rshift"

    btn.p.esc = "escape"

end

return btn