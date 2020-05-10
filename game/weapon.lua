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
    -- Determine the minimum point. Can't be behind the ship.
    local minimum = 800
    if start.x > 800 then
      minimum = start.x + 100
    end

    -- Set the X peak point
    peakPoint.x = math.random(minimum, 1324)
  else
    -- Determine the maximum point. Can't be behind the ship.
    local maximum = 500
    if start.x < 500 then
      maximum = start.x - 100
    end

    -- Set the X peak point
    peakPoint.x = math.random(25, maximum)
  end
  print(peakPoint.x)

  -- Determine the switching point on the y-axis
  peakPoint.y = (375 - start.y) / 2

  -- Spawn the missile
  orb:spawn(start.x, start.y, peakPoint)
end

return Weapon
