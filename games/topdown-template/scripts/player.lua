
local player = {}

function player.load(world)
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    player.x = 0
    player.y = 0
    player.dirx = 0
    player.diry = 0
    player.spd = 50

    player.xspd = 0
    player.yspd = 0

    player.spawnX = 350
    player.spawnY = 250

    player.sprite = love.graphics.newImage("/sprites/players/player.png")
    player.spriteWidth = 16
    player.spriteHeight = 16

    player.image_scale = 1
    player.image_xscale = player.image_scale
    player.image_yscale = player.image_scale
    player.image_speed = 0.1

    player.collider = world:newBSGRectangleCollider(
        player.spawnX,
        player.spawnY,
        15,
        15,
        1)

    player.collider:setFixedRotation(true)

    player.spriteSheet = love.graphics.newImage("/sprites/players/player.png")
    player.grid = anim8.newGrid(player.spriteWidth, player.spriteHeight, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animations = {}
    player.animations.move = anim8.newAnimation(player.grid("1-6", 1), player.image_speed)

    player.anim = player.animations.move
end

function player.update(dt)

    player.dirx = 0
    player.diry = 0

    if btn.left then
        player.dirx = -1
        player.image_xscale = -player.image_scale
    end

    if btn.right then
        player.dirx = 1
        player.image_xscale = player.image_scale
    end

    if btn.up then
        player.diry = -1
    end
    
    if btn.down then
        player.diry = 1
    end

    if player.dirx == 0 and player.diry == 0 then
        player.anim:gotoFrame(1)
    end

    player.xspd = player.dirx * player.spd
    player.yspd = player.diry * player.spd

    player.collider:setLinearVelocity(player.xspd,player.yspd)
    --player.x = player.x + (player.dirx * player.spd)
    --player.y = player.y + (player.diry * player.spd)

    player.anim:update(dt)

    player.x = player.collider:getX()
    player.y = player.collider:getY() - player.spriteHeight / 2
end

function player.draw()
    player.anim:draw(player.spriteSheet, player.x - (player.spriteWidth / 2 * player.image_xscale), player.y, nil, player.image_xscale, player.image_yscale)
end

return player