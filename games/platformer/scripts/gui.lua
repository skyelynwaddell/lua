local GUI = {}
local Player = require("scripts/player")

--LOAD
function GUI:load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    self.screenW = love.graphics.getWidth()
    self.screenH = love.graphics.getHeight()

    self.height = 100
    self.font = love.graphics.newFont("fonts/ipixelu.ttf", 64)

    self.coins = {}
    self.coins.img = love.graphics.newImage("sprites/objects/coin.png")
    self.coins.width = self.coins.img:getWidth()
    self.coins.height = self.coins.img:getHeight()
    self.coins.scale = 3
    self.coins.x = 50
    self.coins.y = 16
end

--UPDATE
function GUI:update(dt)
end

--DRAW
function GUI:draw()
    love.graphics.setFont(self.font)
    self:background()
    self:displayCoins()

    love.graphics.origin()
end

--BACKGROUND
function GUI:background()
    --draw black background for hud
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, self.screenW , self.height)
    love.graphics.setColor(1, 1, 1, 1)
end

--DISPLAY COINS
function GUI:displayCoins()
    --draw coins on the hud
    love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)
    love.graphics.print(Player.coins,self.coins.x + 70,self.coins.y - 20,0)
    love.graphics.print(Player.health.current,self.coins.x + 200,self.coins.y - 20,0)
end

return GUI