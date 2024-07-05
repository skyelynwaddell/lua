--OBJECT CLASS
local Object = {}
Object.__index = Object

--USE PHYSICS
function Object.usePhysics(instance, collisionObject, solid)

    -- instance [table]
    -- collisionObj [string or table of object]
    -- solid [bool]

    --instance physics object
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World,instance.x,instance.y,"dynamic")
    instance.physics.shape = love.physics.newRectangleShape(instance.width,instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(not solid)
    instance.physics.fixture:setUserData(collisionObject)

    return instance
end

--UPDATE ALL
function Object:UpdateAll(instanceTable, dt)
    --loop through all instances, and call their update methods
    for index, instance in ipairs(instanceTable) do
        instance:update(dt)

        if instance.toBeRemoved then
            instance:remove()
        end

     end
end

--ADD INSTANCE
function Object:addInstance(instanceTable, instance)
    table.insert(instanceTable, instance)
end

--DRAW ALL
function Object:DrawAll(instanceTable)
    for i, instance in ipairs(instanceTable) do
        instance:draw()
    end
end

--REMOVE   
function Object:Remove(instanceTable)
    for i, instance in ipairs(instanceTable) do
        if instance == self then
            self.physics.body:destroy()
            table.remove(instanceTable, i)
            break
        end
    end
end

--CHECK REMOVE
function Object:checkRemove()
    if self.toBeRemoved then
        self:remove()
    end
end

--REMOVE ALL
function Object:RemoveAll(instanceTable)
    for i, obj in ipairs(instanceTable) do
        obj.physics.body:destroy()
    end
    return {}
end

--DRAW SELF
function Object:DrawSelf()
    love.graphics.draw(self.img,self.x,self.y, 0, 1, 1, self.width/2, self.height/2)
end

--DRAW ANIMATED SELF
function Object:DrawAnimatedSelf()
    love.graphics.draw(self.animation.draw,self.x,self.y, 0, 1, 1, self.width/2, self.height/2)
end

function Object:colliding(aUserData, bUserData, colliderType, collisionCallback)
    if aUserData == self or bUserData == self then
        if type(aUserData) == "table" and aUserData.type == colliderType then
            for k, v in pairs(aUserData) do
                if k == "hp" then
                    print(k, v.current)
                    print(aUserData.type)
                    collisionCallback(aUserData)
                end
            end
        elseif type(bUserData) == "table" and bUserData.type == colliderType then
            for k, v in pairs(bUserData) do
                if k == "hp" then
                    print(k, v.current)
                    print(bUserData.type)
                    collisionCallback(bUserData)
                end
            end
        end
    end
end

--BEGIN CONTACT
function Object:BeginContact(data)

    --[[
        data = { 
            a, b, 
            table [table], 
            collisionObj [table],  
            destroyOnContact [bool],
            callback [function]
        }
    ]]

    --loop through all objects
    for i, instance in ipairs(data.table) do

        --the two objects we should check collisions between
        local aFixture = instance.physics.fixture
        local bFixture = data.collisionObj.physics.fixture

        if placeMeeting(data.a, data.b, aFixture, bFixture) then
            --obj and player have collided
            data.callback()

            if data.destroyOnContact == true then
                instance.toBeRemoved = true
            end
        end
    end
end

--BEGIN LAYER CONTACT
function Object:BeginLayerContact(a, b, layerName)
    local aData = a:getUserData()
    local bData = b:getUserData()

    if aData == layerName or bData == layerName then
        return true
    else return false
    end
end

--MOVE OBJECT
function Object:Move(spd, dir)
    local dx = spd * math.cos(dir)
    local dy = spd * math.sin(dir)

    self.physics.body:setLinearVelocity(dx, dy)

    self.x = self.physics.body:getX()
    self.y = self.physics.body:getY()
end

--DIRECTION HELPER
function Object.dir(_dir)
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

--ANIMATE
function Object:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

--SET NEW FRAME
function Object:setNewFrame()
    local anim = self.animation[self.state]

    --increment by 1, and reset to 1 when we reach animation total frames
    anim.current = (anim.current % anim.total) + 1

    self.animation.draw = anim.img[anim.current]
end


return Object