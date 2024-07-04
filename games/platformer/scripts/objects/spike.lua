--SPIKE
local Spike = {}
Spike.__index = Spike
local ActiveSpikes = {}
local Player = require("scripts/player")
local Object = require("scripts.class.object")

setmetatable(Spike, Object)

--NEW
function Spike.new(x,y)
    local instance = setmetatable({}, Spike)
    instance.x = x
    instance.y = y
    instance.img = love.graphics.newImage("sprites/objects/spike.png")
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()

    Spike.usePhysics(instance, "Spike", false)
    Spike:addInstance(ActiveSpikes, instance)
end

--UPDATE ALL
function Spike:updateAll(dt)
    self:updateAll(ActiveSpikes, dt)
end

--DRAW
function Spike:draw()
    self:DrawSelf()
end

--DRAW ALL
function Spike:drawAll()
    self:DrawAll(ActiveSpikes)
end

--BEGIN CONTACT
function Spike:beginContact(a, b, collision)

    -- PLAYER / SPIKE COLLISION
    local collisionCallback = function()
        Player:takeDamage(10)
    end

    self:BeginContact({
        a=a, b=b,
        table = ActiveSpikes,
        collisionObj = Player,
        destroyOnContact = true,
        callback = collisionCallback
    })

end

--REMOVE ALL
function Spike:removeAll()
    ActiveSpikes = self:RemoveAll(ActiveSpikes)
end

return Spike