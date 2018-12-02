local Math = require("game.math")

local Weapon = {}

-- Create a missile entity
function Weapon.createMissile(id)
  return {
    id = id,
    type = "missile",
    graphic = "missile",
    rotation = rotation,
    x = -32,
    y = -32,
    vX = 0,
    vY = 0,
    delay = 0 -- Missiles always spawn immediately
  }
end

-- Fires a missile in the direction specified
function Weapon.fireMissile(missile, start, destination)
  -- Calculate the velocity
  local velocity = Math.calculateVelocity(start, destination, 20)

  -- Determine the rotation
  local rotation = Math.calculateRotation(start, destination)

  -- Spawn the missile
  missile:spawn(start.x, start.y, velocity.x, velocity.y, rotation)
end

return Weapon
