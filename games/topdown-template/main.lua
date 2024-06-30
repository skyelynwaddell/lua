load = require("load")
update = require("update")
draw = require("draw")



function love.load()
load.init()
end

function love.update(dt)
update.init(dt)

end

function love.draw()
draw.init()
end