local Enemy = {}
Enemy.__index = Enemy
local ActiveEnemys = {}
local Player = require("scripts/player")

--NEW
function Enemy.new(x,y)
    local instance = setmetatable({}, Enemy)

    --instance properties
    instance.x = x
    instance.y = y

    --instance animation / sprites
    instance.state = "idle"
    instance.animation = { timer=0, rate=0.1}
    instance.animation.idle = {total=4, current=1, img=Enemy.idleAnim}
    instance.animation.run = {total=4, current=1, img=Enemy.runAnim}
    instance.animation.draw = instance.animation.idle.img[1]

    --instance physics object
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World,instance.x,instance.y,"static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width,instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    instance.physics.fixture:setUserData("Enemy1")

    --insert into active table
    table.insert(ActiveEnemys, instance)
end

--LOAD ASSETS
function Enemy.loadAssets()
    Enemy.idleAnim = {}
    Enemy.runAnim = {}

    --IDLE
    for i=1 , 4 do
        Enemy.idleAnim[i] = love.graphics.newImage("/sprites/enemies/test/".. i ..".png")
    end

    --RUN
    for i=1 , 4 do
        Enemy.runAnim[i] = love.graphics.newImage("/sprites/enemies/test/".. i ..".png")
    end

    --asset properties
    Enemy.width = Enemy.idleAnim[1]:getWidth()
    Enemy.height = Enemy.idleAnim[1]:getHeight()

end

--UPDATE
function Enemy:update(dt)
    self:animate(dt)
end

--UPDATE ALL
function Enemy.updateAll(dt)
    for index, instance in ipairs(ActiveEnemys) do
       instance:update(dt) 
    end
end

--ANIMATE
function Enemy:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

--SET NEW FRAME
function Enemy:setNewFrame()
    local anim = self.animation[self.state]

    --increment by 1, and reset to 1 when we reach animation total frames
    anim.current = (anim.current % anim.total) + 1

    self.animation.draw = anim.img[anim.current]
end

--DRAW
function Enemy:draw()
    love.graphics.draw(self.animation.draw,self.x,self.y, 0, 1, 1, self.width/2, self.height/2)
end

--DRAW ALL
function Enemy.drawAll()
    for i, instance in ipairs(ActiveEnemys) do
        instance:draw()
    end
end

--BEGIN CONTACT
function Enemy.beginContact(a, b, collision)

    --loop through all Enemys
    for i, instance in ipairs(ActiveEnemys) do

        local aFixture = instance.physics.fixture
        local bFixture = Player.physics.fixture

        if placeMeeting(a,b,aFixture,bFixture) then
            --Enemy and player have collided
            Player:takeDamage(10)
            return true
        end
    end
end

--REMOVE ALL
function Enemy:removeAll()
    for i, enemy in ipairs(ActiveEnemys) do
        enemy.physics.body:destroy()
    end
    ActiveEnemys = {}
end

return Enemy