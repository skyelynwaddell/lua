local game = {}

function game.load()
    
    game.scale = 5
    game.map = sti("/tilesets/map2/map2.lua")
    game.mapW = game.map.width * game.map.tilewidth
    game.mapH = game.map.height * game.map.tileheight
    game.screenW = love.graphics.getWidth()
    game.screenH = love.graphics.getHeight()

end

function game.draw()
    -- Apply scaling

    love.graphics.push()
    love.graphics.scale(math.floor(game.scale), math.floor(game.scale))

    game.map:drawLayer(game.map.layers["ground"])
    game.map:drawLayer(game.map.layers["objects"])

end

return game