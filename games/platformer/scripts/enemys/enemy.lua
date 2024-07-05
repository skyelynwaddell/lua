--ENEMY
local Enemy = {}
Enemy.__index = Enemy
local ActiveEnemys = {}
local Player = require("scripts/player")
local Object = require("scripts.class.object")
local PlayerBullet = require("scripts/objects/playerbullet")

setmetatable(Enemy, Object)

--NEW
function Enemy.new(x,y)
    local instance = setmetatable({}, Enemy)

    --instance properties
    instance.type = "Enemy"
    instance.x = x
    instance.y = y
    instance.width = 16
    instance.height = 16
    instance.hp = { current = 100, max = 100 }
    instance.toBeRemoved = false

    --instance animation / sprites
    instance.state = "idle"
    instance.animation = { timer=0, rate=0.1}
    instance.animation.idle = {total=4, current=1, img=Enemy.idleAnim}
    instance.animation.run = {total=4, current=1, img=Enemy.runAnim}
    instance.animation.draw = instance.animation.idle.img[1]

    Enemy.usePhysics(instance, instance, false)
    Enemy:addInstance(ActiveEnemys, instance)
end

--LOAD ASSETS
function Enemy:loadAssets()
    self.idleAnim = {}
    self.runAnim = {}

    --IDLE
    for i=1 , 4 do
        self.idleAnim[i] = love.graphics.newImage("/sprites/enemies/test/".. i ..".png")
    end

    --RUN
    for i=1 , 4 do
        self.runAnim[i] = love.graphics.newImage("/sprites/enemies/test/".. i ..".png")
    end

    --asset properties
    self.width = self.idleAnim[1]:getWidth()
    self.height = self.idleAnim[1]:getHeight()
end

--UPDATE
function Enemy:update(dt)
    self:animate(dt)
    self:checkRemove()
end

--UPDATE ALL
function Enemy:updateAll(dt)
    self:UpdateAll(ActiveEnemys, dt)
end

--DRAW
function Enemy:draw()
    self:DrawAnimatedSelf()
end

--DRAW ALL
function Enemy:drawAll()
    self:DrawAll(ActiveEnemys)
end

--REMOVE
function Enemy:remove()
    self:Remove(ActiveEnemys)
end

--REMOVE ALL
function Enemy:removeAll()
    self:RemoveAll(ActiveEnemys)
end

--TAKE DAMAGE
function Enemy:takeDamage(amount)
    if self.hp.current > 0 then
        self.hp.current = self.hp.current - amount
    else
        self:die()
    end
end

--DIE
function Enemy:die()
    self.toBeRemoved = true
end


--BEGIN CONTACT
function Enemy:beginContact(a, b, collision)

    -- PLAYER / ENEMY COLLISION
    local playerCollisionCallback = function()
        Player:takeDamage(10)
    end

    self:BeginContact({
        a=a, b=b,
        table = ActiveEnemys,
        collisionObj = Player,
        destroyOnContact = false,
        callback = playerCollisionCallback
    })
end



return Enemy