local PlayerBullet = {}
PlayerBullet.__index = PlayerBullet
local ActivePlayerBullets = {}
--local Player = require("scripts/player")

--NEW
function PlayerBullet.new(x,y,spd,dir)
    local instance = setmetatable({}, PlayerBullet)

    --instance properties
    instance.x = x
    instance.y = y
    instance.spd = spd
    instance.dir = dir

    --instance sprite
    instance.img = love.graphics.newImage("sprites/assets/playerbullet.png")
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
    table.insert(ActivePlayerBullets, instance)
end

--UPDATE
function PlayerBullet:update(dt)

    --check if needs to be removed
    self:checkRemove()
end

--UPDATE ALL
function PlayerBullet.updateAll(dt)
    --loop through all instances, and call their update methods
    for index, instance in ipairs(ActivePlayerBullets) do
       instance:update(dt) 
       instance:move(instance.spd,instance.dir,dt)
    end
end

--DRAW
function PlayerBullet:draw()
    love.graphics.draw(self.img,self.x,self.y, 0, 1, 1, self.width/2, self.height/2)
end

--DRAW ALL
function PlayerBullet.drawAll()
    for i, instance in ipairs(ActivePlayerBullets) do
        instance:draw()
    end
end

--REMOVE
function PlayerBullet:remove()
    for i, instance in ipairs(ActivePlayerBullets) do
        if instance == self then
            self.physics.body:destroy()
            table.remove(ActivePlayerBullets, i)
        end
    end
end

--CHECK REMOVE
function PlayerBullet:checkRemove()
    if self.toBeRemoved then
        self:remove()
    end
end

--MOVE BULLET
function PlayerBullet:move(spd, dir, dt)
    local dx = spd * math.cos(dir)
    local dy = spd * math.sin(dir)

    self.x = self.x + dx * dt
    self.y = self.y + dy * dt
end

function PlayerBullet.dir(_dir)
    --supported string types
    --right
    --left
    --up
    --down
    --topleft
    --topright
    --bottomleft
    --bottomright

    local dir = 0
    
    if _dir == "right" then
        dir = 0
    elseif _dir == "left" then
        dir = math.pi
    elseif _dir == "up" then
        dir = -math.pi / 2
    elseif _dir == "down" then
        dir = math.pi / 2
    elseif _dir == "topleft" then
        dir = -3 * math.pi / 4
    elseif _dir == "topright" then
        dir = -math.pi / 4
    elseif _dir == "bottomleft" then
        dir = 3 * math.pi / 4
    elseif _dir == "bottomright" then
        dir = math.pi / 4
    end
    

    return dir
end

--BEGIN CONTACT
function PlayerBullet.beginContact(a, b, collision)

    --loop through all PlayerBullets
    for i, instance in ipairs(ActivePlayerBullets) do

        --check if a or b is a PlayerBullet
        if a == instance.physics.fixture or b == instance.physics.fixture then
            
            --check if a or b is the player
            if a == Player.physics.fixture or b == Player.physics.fixture then
                
                --PlayerBullet and player have collided
                return true
            end
        end
    end
end

--REMOVE ALL
function PlayerBullet:removeAll()
    for i, PlayerBullet in ipairs(ActivePlayerBullets) do
        PlayerBullet.physics.body:destroy()
    end
    ActivePlayerBullets = {}
end

return PlayerBullet