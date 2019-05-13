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

-- Create an orb entity
function Weapon.createOrb(id)
  return {
    id = id,
    type = "orb",
    graphic = "orb",
    rotation = rotation,
    x = -32,
    y = -32,
    vX = 0,
    vY = 0,
    delay = 0 -- Orbs always spawn immediately
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

-- Fires an orb near the player in the direction specified
function Weapon.fireOrb(orb, start, vX)
  -- Peak point
  local peakPoint = { x = 0, y = 0 }

  -- Determine the peak point on the x-axis
  if (vX > 0) then
    peakPoint.x = 1334 -- 10 units off the edge
  else
    peakPoint.x = 10 -- !0 units off the edge
  end

  -- Determine the switching point on the y-axis
  y = (375 - start.y) / 2

  -- Calculate the velocity
  local velocity = Math.calculateVelocity(start, destination, 20)

  -- Create function to keep determining next position
  function calculateNextPosition()
  end

  -- Spawn the missile
  orb:spawn(start.x, start.y, calculateNextPosition)
end

return Weapon
