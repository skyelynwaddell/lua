local Map = require("scripts/map")
local GUI = require("scripts/gui")

local Camera = {
    x = 0,               --camera y
    y = 0,               --camera y
    scale = 3,           --camera scale
    targetX = 0,         --camera target x
    targetY = 0,         --camera target y
    smoothingSpeed = 10, --camera smoothing speed
    guiGap = 34          --for the spacing between offset of the top GUI
}

--APPLY
function Camera:apply()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.push()
    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate(-self.x, -self.y)

    love.graphics.translate(0, GUI.height / self.scale)
end

--CLEAR
function Camera:clear()
    love.graphics.pop()
end

--SET TARGET POSITION
function Camera:setTargetPosition(x, y)
    self.targetX = x - love.graphics.getWidth() / 2 / self.scale
    self.targetY = y - love.graphics.getHeight() / 2 / self.scale
end

--UPDATE 
function Camera:update(dt)
    -- Interpolate towards the target position
    self.x = lerp(self.x, self.targetX, self.smoothingSpeed * dt)
    self.y = lerp(self.y, self.targetY, self.smoothingSpeed * dt)

    -- Constrain the camera to the map boundaries horizontally
    local halfScreenWidth = love.graphics.getWidth() / 2 / self.scale
    if self.x < 0 then
        self.x = 0
    elseif self.x + 2 * halfScreenWidth > Map.width then
        self.x = Map.width - 2 * halfScreenWidth
    end

    -- Constrain the camera to the map boundaries vertically
    local halfScreenHeight = love.graphics.getHeight() / 2 / self.scale
    if self.y < 0 then
        self.y = 0
    elseif self.y + 2 * halfScreenHeight > Map.height then
        self.y = Map.height - 2 * halfScreenHeight
    end
end

return Camera