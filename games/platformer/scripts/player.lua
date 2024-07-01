
local player = {}

function player:new(world, _x, _y)
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    self.spawnX = _x
    self.spawnY = _y

    self.x = self.spawnX
    self.y = self.spawnY
    self.dirx = 0
    self.diry = 0
    self.spd = 50

    self.grvty = 4
    self.onGround = false
    self.jumpHeight = -50
    self.jumpCount = 2

    self.xspd = 0
    self.yspd = 0

    self.sprite = love.graphics.newImage("/sprites/players/player.png")
    self.spriteWidth = 16
    self.spriteHeight = 16

    self.image_scale = 1
    self.image_xscale = self.image_scale
    self.image_yscale = self.image_scale
    self.image_speed = 0.1

    self.collider = world:newBSGRectangleCollider(
        self.spawnX,
        self.spawnY,
        15,
        15,
        1)

        self.collider:setFixedRotation(true)

        self.collider:setPreSolve(function(collider, other, contact)
        -- Detect collision with the ground
        local nx, ny = contact:getNormal()
        if ny > 0 then -- Assuming the ground is below the player
            self.onGround = true
        end
    end)
    self.collider:setPostSolve(function(collider, other, contact)
            --self.onGround = true
    end)

    self.spriteSheet = love.graphics.newImage("/sprites/players/player.png")
    self.grid = anim8.newGrid(self.spriteWidth, self.spriteHeight, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animations = {}
    self.animations.move = anim8.newAnimation(self.grid("1-6", 1), self.image_speed)

    self.anim = self.animations.move

    return self
end

function player:update(dt)

    self.dirx = 0

    --left
    if btn.left then
        self.dirx = -1
        self.image_xscale = -self.image_scale
    end

    --right
    if btn.right then
        self.dirx = 1
        self.image_xscale = self.image_scale
    end

    --animate player
    if self.dirx == 0 and self.diry == 0 then
        self.anim:gotoFrame(1)
    end

    self.xspd = self.dirx * self.spd

    if not self.onGround then
        self.yspd = self.yspd + self.grvty 
    else
        self.yspd = 0
    end

    self.anim:update(dt)

    self.collider:setLinearVelocity(self.xspd,self.yspd)
    self.x = self.collider:getX()
    self.y = self.collider:getY() - self.spriteHeight / 2

    self.onGround = false

end

function player:draw()
    player.anim:draw(player.spriteSheet, player.x - (player.spriteWidth / 2 * player.image_xscale), player.y, nil, player.image_xscale, player.image_yscale)
end

function player:jump(key)
    if key == "space" then
        self.yspd = self.yspd -150
        self.collider:setLinearVelocity(self.xspd, self.yspd)
        self.onGround = false
    end
end

return player