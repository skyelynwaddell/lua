local Spike = {}
Spike.__index = Spike
local ActiveSpikes = {}
local Player = require("scripts/player")

--NEW
function Spike.new(x,y)
    local instance = setmetatable({}, Spike)
    instance.x = x
    instance.y = y
    instance.img = love.graphics.newImage("sprites/objects/spike.png")
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World,instance.x,instance.y,"static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width,instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)

    table.insert(ActiveSpikes, instance)
end

--UPDATE ALL
function Spike.updateAll(dt)
    for index, instance in ipairs(ActiveSpikes) do
       instance:update(dt) 
    end
end

--DRAW
function Spike:draw()
    love.graphics.draw(self.img,self.x,self.y, 0, 1, 1, self.width/2, self.height/2)
end

--DRAW ALL
function Spike.drawAll()
    for i, instance in ipairs(ActiveSpikes) do
        instance:draw()
    end
end

--BEGIN CONTACT
function Spike.beginContact(a, b, collision)

    --loop through all Spikes
    for i, instance in ipairs(ActiveSpikes) do

        --check if a or b is a Spike
        if a == instance.physics.fixture or b == instance.physics.fixture then
            
            --check if a or b is the player
            if a == Player.physics.fixture or b == Player.physics.fixture then
                
                --Spike and player have collided
                Player:takeDamage(10)
                return true
            end
        end
    end
end

--REMOVE ALL
function Spike:removeAll()
    for i, spike in ipairs(ActiveSpikes) do
        spike.physics.body:destroy()
    end
    ActiveSpikes = {}
end

return Spike