--PLAYER BULLET
local Object = require("scripts.class.object")
local PlayerBullet = {}
PlayerBullet.__index = PlayerBullet
local ActivePlayerBullets = {}
setmetatable(PlayerBullet, Object)

--NEW
function PlayerBullet.new(x, y, spd, dir)
    local instance = setmetatable({}, PlayerBullet)

    instance.type = "PlayerBullet"
    instance.x = x
    instance.y = y
    instance.spd = spd
    instance.dir = dir

    instance.img = love.graphics.newImage("sprites/assets/playerbullet.png")
    instance.toBeRemoved = false
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()

    PlayerBullet.usePhysics(instance, instance, false)

    PlayerBullet:addInstance(ActivePlayerBullets, instance)
end

--UPDATE
function PlayerBullet:update(dt)
    self:Move(self.spd, self.dir)
    self:checkRemove()
end

--UPDATE ALL
function PlayerBullet:updateAll(dt)
    self:UpdateAll(ActivePlayerBullets, dt)
end

--DRAW
function PlayerBullet:draw()
    self:DrawSelf()
end

--DRAW ALL
function PlayerBullet:drawAll()
    self:DrawAll(ActivePlayerBullets)
end

--REMOVE
function PlayerBullet:remove()
    self:Remove(ActivePlayerBullets)
end

--BEGIN CONTACT
function PlayerBullet:beginContact(a, b, collision)
    if self:BeginLayerContact(a, b, "Wall") then
        self.toBeRemoved = true
    end

    local _a = a:getUserData()
    local _b = b:getUserData()

    local function _enemyCollisionCallback(obj)
        -- body
        obj:takeDamage(10)
    end

    if _a == self or _b == self then
        if type(_a) == "table" and _a.type == "Enemy" then
            for k, v in pairs(_a) do
                if k == "hp" then
                    print(k, v.current)
                    print(_a.type)
                    _enemyCollisionCallback(_a)
                end
            end
        elseif type(_b) == "table" and _b.type == "Enemy" then
            for k, v in pairs(_b) do
                if k == "hp" then
                    print(k, v.current)
                    print(_b.type)
                    _enemyCollisionCallback(_b)
                end
            end
        end
    end


    -- self:BeginContact({
    --     a=a, b=b,
    --     table = ActivePlayerBullets,
    --     collisionObj = Enemy,
    --     destroyOnContact = false,
    --     callback = _callback
    -- })



    -- -- PLAYER / ENEMY COLLISION
    -- local playerCollisionCallback = function()
    --     print("ouch")
    -- end

    -- self:BeginContact({
    --     a=a, b=b,
    --     table = ActivePlayerBullets,
    --     collisionObj = Enemy,
    --     destroyOnContact = false,
    --     callback = playerCollisionCallback
    -- })
end

--REMOVE ALL
function PlayerBullet:removeAll()
    ActivePlayerBullets = self:RemoveAll(ActivePlayerBullets)
end

return PlayerBullet
