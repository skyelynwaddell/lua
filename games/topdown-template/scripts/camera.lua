_camera = require "/libraries/camera" --camera

local camera = {}

function camera.load()
    cam = _camera()
end

function camera.update()
    -- Calculate camera target position
    local targetX = player.x + (player.spriteWidth / 2) -- Center on player's horizontal position
    local targetY = player.y + (player.spriteHeight / 2) -- Center on player's vertical position

    -- Clamp camera target position
    local halfScreenW = (game.screenW / game.scale) / 2
    local halfScreenH = (game.screenH / game.scale) / 2

    targetX = math.ceil(math.max(halfScreenW, math.min(targetX, game.mapW - halfScreenW))) * game.scale
    targetY = math.ceil(math.max(halfScreenH, math.min(targetY, game.mapH - halfScreenH))) * game.scale

    -- Interpolate camera movement for smooth follow
    local smoothness = 5
    cam.x = math.floor(cam.x + (targetX - cam.x) * smoothness * love.timer.getDelta())
    cam.y = math.floor(cam.y + (targetY - cam.y) * smoothness * love.timer.getDelta())

    -- Update camera position
    cam:lookAt(cam.x, cam.y)
end

return camera