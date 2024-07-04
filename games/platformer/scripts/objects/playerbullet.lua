--PLAYER BULLET
local Object = require("scripts.class.object")
local PlayerBullet = {}
PlayerBullet.__index = PlayerBullet
local ActivePlayerBullets = {}
setmetatable(PlayerBullet, Object)

--NEW
function PlayerBullet.new(x, y, spd, dir)
    local instance = setmetatable({}, PlayerBullet)

    instance.x = x
    instance.y = y
    instance.spd = spd
    instance.dir = dir

    instance.img = love.graphics.newImage("sprites/assets/playerbullet.png")
    instance.toBeRemoved = false
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()

    PlayerBullet.usePhysics(instance,instance,false)
   
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
    if self:BeginLayerContact(a,b, "Wall") then
        self.toBeRemoved = true
    end
end

--REMOVE ALL
function PlayerBullet:removeAll()
    ActivePlayerBullets = self:RemoveAll(ActivePlayerBullets)
end

return PlayerBullet
