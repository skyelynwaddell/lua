load = require("states/load")
update = require("states/update")
draw = require("states/draw")

function love.load()
load.init()
end

function love.update(dt)
update.init(dt)
end

function love.draw()
draw.init()
end

function love.keypressed(key)
    player:jump(key)
end