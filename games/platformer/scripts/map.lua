local STI = require("libraries/sti")
local Coin = require("scripts.objects.coin")
local Spike = require("scripts.objects.spike")
local Enemy = require("scripts.enemys.enemy")

local Map = {}

--INIT
function Map:init()
    --Load tilemap from lua file
    self.level = STI("tilesets/".. self.currentLevel .."/".. self.currentLevel ..".lua", { "box2d" })

    --set world type
    self.level:box2d_init(World)

    --get layers from tilemap (these are the layer names, ie entities, walls, etc)
    self.wallLayer = self.level.layers.walls
    self.entityLayer = self.level.layers.entities
    self.groundLayer = self.level.layers.ground

    --set these layers invisible so they dont render the layer shapes from tiled
    self.wallLayer.visible = false
    self.entityLayer.visible = false

    --get map width / height * tilemap aspect
    local tileSpriteSize = 16
    self.width = Map.groundLayer.width * tileSpriteSize
    self.height = Map.groundLayer.height * tileSpriteSize

    --spawn all entities to the map
    self:spawnEntities()
    self:setupWalls()
end

--LOAD
function Map:load()
    --set current level !! MUST MATCH FILENAME 
    self.currentLevel = "map2"

    --create new world
    love.physics.setMeter(16)  -- Set the scale for physics calculations
    World = love.physics.newWorld(0,0)
    World:setCallbacks(beginContact, endContact)

    self:init()
end

--SPAWN ENTITIES
function Map:spawnEntities()

    --loop through all entity types and spawn accordingly
    for i, instance in ipairs(Map.entityLayer.objects) do

        --COIN
        if instance.type == "coin" then
            Coin.new(instance.x + instance.width/2  , instance.y + instance.height/2)
        
        --SPIKE
        elseif instance.type == "spike" then
            Spike.new(instance.x + instance.width/2  , instance.y + instance.height/2)

        --ENEMY1
        elseif instance.type == "enemy1" then
            Enemy.new(instance.x + instance.width/2  , instance.y + instance.height/2)
        end
    end
end

--ROOM GOTO
function Map:roomGoto(room)
    self.currentLevel = room
    self:init()
end

--CLEAN
function Map:clean()
    self.level:box2d_removeLayer("walls")
    Coin:removeAll()
    Spike:removeAll()
    Enemy:removeAll()
end

--SETUP WALLS
function Map:setupWalls()
    -- Iterate through wall objects and create fixtures
    for _, wall in ipairs(self.wallLayer.objects) do
        local body = love.physics.newBody(World, wall.x + wall.width / 2, wall.y + wall.height / 2, "static")
        local shape = love.physics.newRectangleShape(wall.width, wall.height)
        local fixture = love.physics.newFixture(body, shape)
        fixture:setUserData("Wall")
    end
end

return Map