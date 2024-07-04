--COIN
local Coin = {}
Coin.__index = Coin

local ActiveCoins = {}
local Player = require("scripts/player")
local Object = require("scripts.class.object")

-- inherit from the object class
setmetatable(Coin, Object)

--NEW
function Coin.new(x,y)
    local instance = setmetatable({}, Coin)

    --instance properties
    instance.x = x
    instance.y = y

    --instance sprite
    instance.img = love.graphics.newImage("sprites/objects/coin.png")
    instance.toBeRemoved = false
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()

    Coin.usePhysics(instance, "Coin", false)

    --add instance to active table
    Coin:addInstance(ActiveCoins, instance)
end

--UPDATE
function Coin:update(dt)
    self:checkRemove()
end

--UPDATE ALL
function Coin:updateAll(dt)
    self:UpdateAll(ActiveCoins, dt)
end

--DRAW
function Coin:draw()
    self:DrawSelf()
end

--DRAW ALL
function Coin:drawAll()
    self:DrawAll(ActiveCoins)
end

--REMOVE
function Coin:remove()
    self:Remove(ActiveCoins)
end

--REMOVE ALL
function Coin:removeAll()
    ActiveCoins = self:RemoveAll(ActiveCoins)
end

--BEGIN CONTACT
function Coin:beginContact(a, b, collision)

    -- PLAYER / COIN COLLISION
    local collisionCallback = function()
        Player:increaseCoins()
    end

    self:BeginContact({
        a=a, b=b,
        table = ActiveCoins,
        collisionObj = Player,
        destroyOnContact = true,
        callback = collisionCallback
    })

end

return Coin