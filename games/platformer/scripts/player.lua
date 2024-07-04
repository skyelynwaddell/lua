local Bullet = require("scripts.objects.playerbullet")

local Player = {}

--LOAD
function Player:load()

    --player properties
    self.x = 100
    self.y = 60
    self.width = 20
    self.height = 40
    self.xspd = 0
    self.yspd = 0
    self.maxSpd = 200
    self.acceleration = 2000
    self.friction = 6000
    self.gravity = 500

    self.bulletX = self.x
    self.bulletY = self.y
    self.bulletSpd = 200
    self.bulletDir = 0

    self.health = { current = 100, max = 100 }

    self.grounded = false
    self.alive = true

    self.jumpHeight = -300
    self.jumpCountMax = 1
    self.jumpCount = 0

    self.scale = 1
    self.xscale = 1
    self.yscale = 1

    self.color = {
        red = 1,
        green = 1,
        blue = 1,
        speed = 3
    }

    self.state = "idle"

    --player collectables
    self.coins = 0

    self:physicBodyInit()

    --load all player assets
    self:loadAssets()
end

--UPDATE
function Player:update(dt)
    self:tintReset(dt)
    self:setState()
    self:crouch()
    self:usePhysics()
    self:move(dt)
    self:applyGravity(dt)
    self:animate(dt)
    self:aimDirection()
end

-- PHYSIC BODY INIT
function Player:physicBodyInit()

    --player default physics body
    self.physics = {}
    self.physics.width = self.width
    self.physics.height = self.height
    self.physics.x = self.x
    self.physics.y = self.y
    self.physics.body = love.physics.newBody(World,self.physics.x,self.physics.y,"dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.physics.width, self.physics.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    Player.physics.fixture:setUserData("Player")

end

-- SET STATE
function Player:setState()
    local wasFalling = self.state == "fall"  -- Check if player was falling before

    -- Default state to idle
    self.state = "idle"

    self.bulletX = self.x

    if self.x ~= nil then
        self.bulletY = self.y - 6
    end

    -- CROUCH
    if btn.down and self.yspd == 0 then

        self.bulletY = self.y + 11

        if self.xspd ~= 0 then
            self.state = "crouchwalk"
        else
            self.state = "crouch"
        end
    -- JUMP
    elseif self.yspd < 0 then
        self.state = "jump"
    -- FALL
    elseif self.yspd > 0 then
        self.state = "fall"
    -- RUN
    elseif self.xspd ~= 0 and self.yspd == 0 then
        self.state = "run"
    end

    -- If player was falling but is now on the ground and not moving horizontally
    if wasFalling and self.yspd == 0 and self.xspd == 0 then
        self.state = "idle"
    end

    -- print(self.state)
end


--LOAD ASSETS
function Player:loadAssets()
    self.animation = {timer = 0, rate = 0.1}

    --IDLE
    self.animation.idle = {total = 1, current = 1, img = {}}
    for i = 1, self.animation.idle.total do
        self.animation.idle.img[i] = love.graphics.newImage("sprites/player_robot/idle/".. i ..".png")
    end

    --RUN
    self.animation.run  = {total = 6, current = 1, img = {}}
    for i = 1, self.animation.run.total do
        self.animation.run.img[i] = love.graphics.newImage("sprites/player_robot/run/".. i ..".png")
    end

    --JUMP
    self.animation.jump = {total = 1, current = 1, img = {}}
    for i = 1, self.animation.jump.total do
        self.animation.jump.img[i] = love.graphics.newImage("sprites/player_robot/jump/".. i ..".png")
    end

    --FALL
    self.animation.fall = {total = 1, current = 1, img = {}}
    for i = 1, self.animation.fall.total do
        self.animation.fall.img[i] = love.graphics.newImage("sprites/player_robot/jump/".. i ..".png")
    end

    --CROUCH
    self.animation.crouch = {total = 1, current = 1, img = {}}
    for i = 1, self.animation.crouch.total do
        self.animation.crouch.img[i] = love.graphics.newImage("sprites/player_robot/crouch/".. i ..".png")
    end

    --CROUCHWALK
    self.animation.crouchwalk = {total = 1, current = 1, img = {}}
    for i = 1, self.animation.crouchwalk.total do
        self.animation.crouchwalk.img[i] = love.graphics.newImage("sprites/player_robot/crouch/".. i ..".png")
    end

    --current image
    self.animation.draw = self.animation.idle.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()

end

--ANIMATE
function Player:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

--SET NEW FRAME
function Player:setNewFrame()
    local anim = self.animation[self.state]

    --increment by 1, and reset to 1 when we reach animation total frames
    anim.current = (anim.current % anim.total) + 1

    self.animation.draw = anim.img[anim.current]
end

--SET DIRECTION
function Player:setDirection()
    if btn.right then
        self.xscale = self.scale
    elseif btn.left then
        self.xscale = -self.scale
    end
end

--SET AIM DIRECTION
function Player:aimDirection()

    if self.xscale == 1 then
        self.bulletDir = Bullet.dir("right") -- right

        if btn.aim then
            self.bulletDir = Bullet.dir("topright")-- top right
        end

    elseif self.xscale == -1 then
        self.bulletDir = Bullet.dir("left") -- left

        if btn.aim then
            self.bulletDir = Bullet.dir("topleft") -- top left
        end
    end

    
    if btn.left then
        self.bulletDir = Bullet.dir("left") -- left

    elseif btn.right then
        self.bulletDir = Bullet.dir("right") -- right
    end
    
    if btn.up then
        self.bulletDir = Bullet.dir("up") --up
        
    -- elseif btn.down then
    --     self.bulletDir = math.pi / 2 --down
    end
end

--APPLY GRAVITY
function Player:applyGravity(dt)
    if not self.grounded then
        self.yspd = self.yspd + self.gravity * dt
    end
end

--CROUCH
function Player:crouch()
end

--USE PHYSICS
function Player:usePhysics()
    self.x = self.physics.body:getX();
    self.y = self.physics.body:getY();
    self.physics.body:setLinearVelocity(self.xspd, self.yspd)
end

--APPLY FRICTION
function Player:applyFriction(dt)
    if self.xspd > 0 then
        self.xspd = math.max(self.xspd - self.friction * dt, 0)
    elseif self.xspd < 0 then
        self.xspd = math.max(self.xspd + self.friction * dt, 0)
    end
end

--MOVE
function Player:move(dt)
    if btn.right then
        self.xspd = math.min(self.xspd + self.acceleration * dt, self.maxSpd)
    elseif btn.left then
        self.xspd = math.max(self.xspd - self.acceleration * dt, -self.maxSpd)
    else
        self:applyFriction(dt)
    end
end

--BEGIN CONTACT
function Player:beginContact(a, b, collision)

    if self.grounded then return end

    local nx, ny = collision:getNormal()

    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        elseif ny < 0 then
            self.yspd = 0
        end
    elseif b == self.physics.fixture  then
        if ny < 0 then
            self:land(collision)
        elseif ny > 0 then
            self.yspd = 0
        end
    end
end

--END CONTACT
function Player:endContact(a, b, collision)
    if a == self.physics.fixture
    or b == self.physics.fixture
    then
        if self.currentGroundCollision == collision then
            self.grounded = false
            self.jumpCount = 0
        end
    end
end

--LAND
function Player:land(collision)
    self.currentGroundCollision = collision
    self.yspd = 0
    self.jumpCount = 0
    self.grounded = true
end

--JUMP
function Player:jump(key)
    if key == btn.p.a and self.jumpCount < self.jumpCountMax then
        self.jumpCount = self.jumpCount + 1
        self.yspd = self.jumpHeight
        self.grounded = false
    end
end

--INCREASE COINS
function Player:increaseCoins()
    self.coins = self.coins + 1
end

--TAKE DAMAGE
function Player:takeDamage(amount)
    if self.health.current > 0 then
        self.health.current = self.health.current - amount
        self:tintColor(1,0,0)
    else
        self:die()
    end
    --print(self.health.current)
end

--DIE
function Player:die()
    self.alive = false
    self:respawn()
end

--RESPAWN
function Player:respawn()
    if self.alive == false then
        self.x = self.spawnX
        self.y = self.spawnY

        self.health.current = self.health.max
        self.alive = true
    end
end

--TINT COLOR
function Player:tintColor(r,g,b)
    self.color.red = r
    self.color.green = g
    self.color.blue = b
end

--TINT RESET
function Player:tintReset(dt)
    local tintSpeed = 0.03
    self.color.red = self.color.red + tintSpeed
    self.color.green = self.color.green + tintSpeed
    self.color.blue = self.color.blue + tintSpeed

    self.color.red = math.min(self.color.red + self.color.red * dt, 1)
    self.color.green = math.min(self.color.green + self.color.green * dt, 1)
    self.color.blue = math.min(self.color.blue + self.color.blue * dt, 1)
end

--SHOOT
function Player:shoot(key)
    if key == btn.p.b then 
        local bullet = Bullet.new(self.bulletX, self.bulletY,self.bulletSpd,self.bulletDir)
    end
end

--DRAW
function Player:draw()
    if self.animation.draw then
        love.graphics.setColor(self.color.red,self.color.green,self.color.blue)
        love.graphics.draw(self.animation.draw, self.x, self.y, 0, self.xscale, self.yscale, self.animation.width/2, self.animation.height/2 + 4)
        love.graphics.setColor(1,1,1,1)
    end
    --love.graphics.rectangle("line", self.x - self.physics.width/2, self.y - self.physics.height/2, self.physics.width, self.physics.height)

    Player:setDirection()

end

return Player