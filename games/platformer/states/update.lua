local update = {}

--UPDATE
function update.init(dt)
    btn.update()
    world:update(dt)
    player:update(dt)
    camera.update()

end

return update