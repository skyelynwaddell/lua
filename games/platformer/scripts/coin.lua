local Coin = {}
Coin.__index = Coin
local ActiveCoins = {}
local Player = require("scripts/player")

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

    --instance physics object
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World,instance.x,instance.y,"static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width,instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)

    --add instance to active table
    table.insert(ActiveCoins, instance)
end

--UPDATE
function Coin:update(dt)
    --check if needs to be removed
    self:checkRemove()
end

--UPDATE ALL
function Coin.updateAll(dt)
    --loop through all instances, and call their update methods
    for index, instance in ipairs(ActiveCoins) do
       instance:update(dt) 
    end
end

--DRAW
function Coin:draw()
    love.graphics.draw(self.img,self.x,self.y, 0, 1, 1, self.width/2, self.height/2)
end

--DRAW ALL
function Coin.drawAll()
    for i, instance in ipairs(ActiveCoins) do
        instance:draw()
    end
end

--REMOVE
function Coin:remove()
    for i, instance in ipairs(ActiveCoins) do
        if instance == self then
            self.physics.body:destroy()
            table.remove(ActiveCoins, i)
        end
    end
end

--CHECK REMOVE
function Coin:checkRemove()
    if self.toBeRemoved then
        self:remove()
    end
end

--BEGIN CONTACT
function Coin.beginContact(a, b, collision)

    --loop through all coins
    for i, instance in ipairs(ActiveCoins) do

        --check if a or b is a coin
        if a == instance.physics.fixture or b == instance.physics.fixture then
            
            --check if a or b is the player
            if a == Player.physics.fixture or b == Player.physics.fixture then
                
                --coin and player have collided\
                Player:increaseCoins()
                instance.toBeRemoved = true
                return true
            end
        end
    end
end

--REMOVE ALL
function Coin:removeAll()
    for i, coin in ipairs(ActiveCoins) do
        coin.physics.body:destroy()
    end
    ActiveCoins = {}
end

return Coin