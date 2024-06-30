local update = {}

--UPDATE
function update.init(dt)
    world:update(dt)
    player.update(dt)
    camera.update()

end

return update