local resources = require("game.resources")
local gameAudio = require("game.sounds")
local weapon = require("game.weapon")

-- Entities that this entity can collide with
local collidableEntities = {
  missle = true
}

-- Create a pirate
function pirate(properties, graphic)
  local M = {}

  M.id = properties.id
  M.type = "pirate"
  M.initialized = false
  M.collidable = false
  M.shape = "rectangle"

  local exploding = false
  local shotFired = false

  -- Initialize the pirate
  function M.initialize()
    if M.initialized then
      return
    end

    -- Flying
    graphic.initialize("alive")

    -- Set flags
    M.collidable = true
    M.initialized = true
  end

  -- Update the pirate
  function M.update()
    if not M.initialized then
      return
    end

    -- Check the current position
    local position = graphic.position()

    -- Slowly decrease velocity if exploding
    if exploding then
      properties.vX = properties.vX * .95
      properties.vY = properties.vY * .95
    end

    -- Fire the shot if necessary
    if not shotFired and position.x > 750 then
      local missleSetup = weapon.createMissle("P1")
      local missle = resources.
      weapon.fireMissle(position, { x = 667, y = 750 }, missle)
      shotFired = true
    end

    graphic.move(position.x + properties.vX, position.y + properties.vY)
  end

  -- Gets the position
  function M.position()
    if not M.initialized then
      return nil
    end

    return graphic.position()
  end

  -- Gets the size
  function M.size()
    if not M.initialized then
      return nil
    end

    return graphic.size()
  end

  -- Can this entity collide with a given type
  function M.canCollide(type)
    if not M.collidable then
      return false
    end

    return collidableEntities[type] ~= nil
  end

  -- Called when the pirate has collided with something
  function M.collided(entity)
    -- No longer collidable
    M.collidable = false

    -- Explode
    graphic.setGraphic("exploding")

    -- Play explosion sound
    gameAudio.playBasicExplosionSound()

    -- Mark as exploding
    exploding = true
  end

  -- Release the pirate
  function M.release()
    if not M.initialized then
      return
    end

    graphic.release()

    M.initialized = false
  end

  return M
end

return pirate
