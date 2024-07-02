local PlayerBullet = {}
PlayerBullet.__index = PlayerBullet
local ActivePlayerBullets = {}

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

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    instance.physics.fixture:setUserData(instance)  -- Set user data to instance

    table.insert(ActivePlayerBullets, instance)
end

--UPDATE
function PlayerBullet:update(dt)
    if not self.toBeRemoved then
        self:move(self.spd, self.dir)
    end
end

--UPDATE ALL
function PlayerBullet.updateAll(dt)
    for i = #ActivePlayerBullets, 1, -1 do
        local instance = ActivePlayerBullets[i]
        instance:update(dt)
        if instance.toBeRemoved then
            instance:remove()
        end
    end
end

--DRAW
function PlayerBullet:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
end

--DRAW ALL
function PlayerBullet.drawAll()
    for i = #ActivePlayerBullets, 1, -1 do
        local instance = ActivePlayerBullets[i]
        if not instance.toBeRemoved then
            instance:draw()
        end
    end
end

--REMOVE
function PlayerBullet:remove()
    for i, instance in ipairs(ActivePlayerBullets) do
        if instance == self then
            self.physics.body:destroy()
            table.remove(ActivePlayerBullets, i)
            break
        end
    end
end

--MOVE BULLET
function PlayerBullet:move(spd, dir)
    local dx = spd * math.cos(dir)
    local dy = spd * math.sin(dir)

    self.physics.body:setLinearVelocity(dx, dy)

    self.x = self.physics.body:getX()
    self.y = self.physics.body:getY()
end

--DIRECTION HELPER
function PlayerBullet.dir(_dir)

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
function PlayerBullet:beginContact(a, b, collision)
    local aData = a:getUserData()
    local bData = b:getUserData()

    if aData == "Player" or bData == "Player" then
        print("player")
    elseif aData == "Wall" or bData == "Wall" then
        print("wall")
        self.toBeRemoved = true
    end
end

--REMOVE ALL
function PlayerBullet.removeAll()
    for i, playerBullet in ipairs(ActivePlayerBullets) do
        playerBullet.physics.body:destroy()
    end

    ActivePlayerBullets = {}
end

return PlayerBullet
