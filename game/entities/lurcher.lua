local gameAudio = require("game.sounds")

-- Entities that this entity can collide with
local collidableEntities = {
  missle = true,
  player = true
}

-- Create a lurcher
function lurcher(properties, graphic)
  local M = {}

  M.id = properties.id
  M.type = "lurcher"
  M.initialized = false
  M.collidable = false
  M.shape = "circle"

  local exploding = false
  local attacking = false
  local killedPlayer = false

  -- Initialize the lurcher
  function M.initialize()
    if M.initialized then
      return
    end

    graphic.initialize("alive")

    M.initialized = true
  end

  -- Update the lurcher
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
    if (not killedPlayer and not attacking) then
      graphic.move(position.x + properties.vX, position.y + properties.vY)
    end
  end

  -- Do anything that needs to be done if the world has stopped moving
  function M.handleWorldStoppedMoving()
  end

  -- Do anything that needs to be done if a powerup affecting this entity is activated
  function M.handleCratePowerActivated(powerUpName)
    if (powerUpName == "lurcher") then
      attacking = true
      -- TODO: Play any attacking sound and/or animation if needed
      graphic.moveTransition({x = 667, y = 375, time = 1000})
      timer.performWithDelay(200, becomeCollidable)
    end
  end

  function becomeCollidable()
    M.collidable = true
    gameAudio.playBasicExplosionSound()
  end

  -- listener to invoke after attack transition is completed
  function attackComplete()

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

  -- Called when the lurcher has collided with something
  function M.collided(entity)
    -- No longer collidable
    M.collidable = false

    if (entity.type == "player") then
      -- TODO: Play lurcher laugh audio and set another graphic if desired
      -- Stop the lurcher where the player left off so it can laugh at the player
      killedPlayer = true
    else
      -- Explode
      graphic.setGraphic("exploding")

      -- Play lurcher explosion sound
      gameAudio.playBasicExplosionSound()

      -- Mark as exploding
      exploding = true
    end
  end

  -- Release the lurcher
  function M.release()
    if not M.initialized then
      return
    end

    graphic.release()

    M.initialized = false
  end

  return M
end

return lurcher
