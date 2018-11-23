local gameAudio = require("game.sounds")

-- Entities that this entity can collide with
local collidableEntities = {
  missle = true
}

-- Create a crate
function crate(properties, graphic)
  local M = {}

  M.id = properties.id
  M.type = "crate"
  M.initialized = false
  M.collidable = false
  M.shape = "rectangle"
  M.powerUp = properties.powerUp
  M.lurcherId = properties.lurcherId

  -- Events the crate can trigger
  local powerActivated = nil

  local exploding = false

  -- Initialize the crate
  function M.initialize()
    if M.initialized then
      return
    end

    graphic.initialize("floating")

    M.collidable = true
    M.initialized = true
  end

  -- Update the crate
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
    else
      graphic.rotate(-.2)
    end

    -- Move it
    graphic.move(position.x + properties.vX, position.y + properties.vY)
  end

  -- Do anything that needs to be done if the world has stopped moving
  function M.handleWorldStoppedMoving()
  end

  -- Do anything that needs to be done if a powerup affecting this entity is activated
  function M.handleCratePowerActivated(powerUpName)
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

    -- Append radius
    local size = graphic.size()
    size.radius = size.width / 2

    return size
  end

  function M.canCollide(type)
    if not M.collidable then
      return false
    end

    return collidableEntities[type] ~= nil
  end

  function M.setPowerActivatedHandler(handler)
    if type(handler) ~= "function" then
      error("Power activated handler must be a function")
    end

    powerActivated = handler
  end

  -- Called when the crate has collided with something
  function M.collided(entity)
    -- No longer collidable
    M.collidable = false

    -- Explode
    graphic.setGraphic("exploding")

    -- Play crate explosion sound
    gameAudio.playBasicExplosionSound()

    -- Mark as exploding
    exploding = true

    -- Call global handler to activate power up
    powerActivated(M.id)
  end

  -- Release the crate
  function M.release()
    if not M.initialized then
      return
    end

    graphic.release()

    M.initialized = false
  end

  return M
end

return crate
