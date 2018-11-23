local gameAudio = require("game.sounds")

-- Entities that this entity can collide with
local collidableEntities = {
  missle = true,
  player = true
}

-- Create a alien
function alien(properties, graphic)
  local M = {}

  M.id = properties.id
  M.type = "alien"
  M.initialized = false
  M.collidable = false
  M.destroyed = false
  M.shape = "rectangle"

  local lastShot = 45

  -- Initialize the alien
  function M.initialize()
    if M.initialized then
      return
    end

    graphic.initialize("alive")

    M.collidable = true
    M.initialized = true
    M.destroyed = false
  end

  -- Update the alien
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

    return graphic.size()
  end

  -- Can collide with a given entity
  function M.canCollide(type)
    if not M.collidable then
      return false
    end

    return collidableEntities[type] ~= nil
  end

  -- Called when the alien has collided with something
  function M.collided(entity)
    -- Disable colliding
    M.collidable = false

    -- Start exploding
    graphic.setGraphic("exploding")

    -- Play alien explosion sound
    gameAudio.playBasicExplosionSound()

    -- Flag as dead
    M.destroyed = true
  end

  -- Release the alien
  function M.release()
    if not M.initialized then
      return
    end

    graphic.release()

    M.initialized = false
  end

  return M
end

return alien
