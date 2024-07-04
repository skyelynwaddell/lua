
--IMPORTS
local Lady = require("libraries/lady")

Player = require("scripts/player")
btn = require("scripts/utils/btn")
Class = require("libraries/hump/class")

local GUI = require("scripts/gui")
local Map = require("scripts/map")
local Camera = require("scripts/camera")
local Coin = require("scripts.objects.coin")
local Spike = require("scripts.objects.spike")
local Enemy = require("scripts.enemys.enemy")
local PlayerBullet = require("scripts.objects.playerbullet")

--GENERAL FUNCTIONS
require("scripts/utils/lerp")
require("scripts/utils/placeMeeting")

--set pixelated filter
love.graphics.setDefaultFilter("nearest", "nearest") 

--LOAD
function love.load()
    Enemy:loadAssets()

    Map:load()
    GUI:load()
    Player:load()

end

--UPDATE
function love.update(dt)
    btn:update()
    World:update(dt)
    GUI:update(dt)
    Player:update(dt)
    Coin:updateAll(dt)
    PlayerBullet:updateAll(dt)
    Enemy:updateAll(dt)
    Camera:setTargetPosition(Player.x, Player.y)
    Camera:update(dt)
end

--DRAW
function love.draw()
    Camera:apply()
    --Rendered within camera view

    Map.level:draw(-Camera.x,-Camera.y+Camera.guiGap, Camera.scale, Camera.scale)
    PlayerBullet:drawAll()
    Player:draw()
    Coin:drawAll()
    Enemy:drawAll()
    Spike:drawAll()

    Camera:clear()
    --Rendered not within camera

    GUI:draw()
end

--KEY PRESSED
function love.keypressed(key)
    Player:jump(key)
    Player:shoot(key)

    if key == "escape" then
        love.event.quit()
    end

    if key == "backspace" then
        Lady.save_all("save", Player)
    end
end

--BEGIN CONTACT COLLISION
function beginContact(a, b, collision)
    if a:getUserData() and a:getUserData().beginContact then
        a:getUserData():beginContact(a, b, collision)
    end
    if b:getUserData() and b:getUserData().beginContact then
        b:getUserData():beginContact(b, a, collision)
    end

    if Coin:beginContact(a, b, collision) then return end
    if Spike:beginContact(a, b, collision) then return end
    if Enemy:beginContact(a, b, collision) then return end
    if PlayerBullet:beginContact(a, b, collision) then return end
    Player:beginContact(a, b, collision)
end

--END CONTACT COLLISION
function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end

