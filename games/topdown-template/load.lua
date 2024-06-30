local load = {}

--LOAD
function load.init()
    
    anim8  = require "/libraries/anim8"      --animations
    sti    = require("/libraries/sti")       --tilemaps
    wf     = require("/libraries/windfield") --physics

    --scripts
    game   = require "/scripts/game"
    camera = require "/scripts/camera"
    player = require "/scripts/player"

    game.load()
    world = wf.newWorld(0,0)
    player.load(world)
    camera.load()

    walls = {}
    if game.map.layers["walls"] then
        for i, obj in pairs(game.map.layers["walls"].objects) do
            local wall = world:newRectangleCollider(obj.x,obj.y,obj.width-1,obj.height-1)
            wall:setType("static")
        end
    end

end

return load