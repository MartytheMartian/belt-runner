local math = require("game.math")
local resources = require("game.resources")

-- Track the number of missles
local missleCount = 0

local M = {}

-- Fires a missle in the direction specified
function M.fireMissle(start, destination)
  -- Calculate the velocity
  local velocity = math.calculateVelocity(start, destination, 20)

  -- Determine the rotation
  local rotation = math.calculateRotation(start, destination)

  -- Increment the missle count
  missleCount = missleCount + 1

  -- Setup the entity
  local missle = {
    id = "M" .. missleCount,
    type = "missle",
    graphic = "missle",
    rotation = rotation,
    x = start.x,
    y = start.y,
    vX = velocity.x,
    vY = velocity.y,
    delay = 0 -- Spawn immediately
  }

  -- Create the entity
  resources.createEntity(missle)
end

return M
