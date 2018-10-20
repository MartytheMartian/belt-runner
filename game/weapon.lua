local math = require("game.math")
local resources = require("game.resources")

local M = {}

-- Create a missle entity
function M.createMissle(id)
  return {
    id = id,
    type = "missle",
    graphic = "missle",
    rotation = rotation,
    x = -32,
    y = -32,
    vX = 0,
    vY = 0,
    delay = 0 -- Missles always spawn immediately
  }
end

-- Fires a missle in the direction specified
function M.fireMissle(missle, start, destination)
  -- Calculate the velocity
  local velocity = math.calculateVelocity(start, destination, 20)

  -- Determine the rotation
  local rotation = math.calculateRotation(start, destination)

  -- Spawn the missle
  missle.spawn(start.x, start.y, velocity.x, velocity.y, rotation)
end

return M
