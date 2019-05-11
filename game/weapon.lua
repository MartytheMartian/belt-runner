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

-- Fires an orb to the destination specified
function Weapon.fireOrb(orb, start, destination)
  -- Calculate the velocity
  local velocity = Math.calculateVelocity(start, destination, 8)

  -- Spawn the missile
  orb:spawn(start.x, start.y, velocity.x, velocity.y)
end

return Weapon
