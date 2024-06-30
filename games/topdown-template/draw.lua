local draw = {}

--DRAW
function draw.init()
    love.graphics.setDefaultFilter("nearest", "nearest")

    cam:attach()
        --objects drawn within the camera
        game.draw()
        player.draw()
        world:draw()

    love.graphics.pop()
    cam:detach()

    --hud elements
end

return draw