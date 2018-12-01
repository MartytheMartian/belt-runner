local Math = require("game.math")

local Weapon = {}

-- Create a missle entity
function Weapon.createMissle(id)
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
function Weapon.fireMissle(missle, start, destination)
  -- Calculate the velocity
  local velocity = Math.calculateVelocity(start, destination, 20)

  -- Determine the rotation
  local rotation = Math.calculateRotation(start, destination)

  -- Spawn the missle
  missle.spawn(start.x, start.y, velocity.x, velocity.y, rotation)
end

return Weapon
