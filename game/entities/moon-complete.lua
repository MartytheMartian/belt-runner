-- This is the half moon at the bottom of the screen that does not house a tentacle.
-- This ends up just being scenery

-- Entities that this entity can collide with
local collidableEntities = {}

-- Create a moon
function moonComplete(properties, graphic)
  local M = {}
  local stopMoving = false

  M.id = properties.id
  M.type = "moonComplete"
  M.initialized = false
  M.collidable = false
  M.destroyed = false
  M.shape = "rectangle"

  -- Initialize the moon
  function M.initialize()
    if M.initialized then
      return
    end

    graphic.initialize()

    M.initialized = true
  end

  -- Update the moon
  function M.update()
    if not M.initialized then
      return
    end

    -- Get the position and size
    local position = graphic.position()
    local size = graphic.size()

    -- Release the moon if off screen
    -- TODO: we may not want to actually release mid level. Might want to wait to clean up at end of level
    if position.x + size.width <= 0 then
      M.release()
      return
    end

    -- Move it
    if not stopMoving then
      graphic.move(position.x + properties.vX, position.y + properties.vY)
    end
  end

  -- Do anything that needs to be done if the world has stopped moving
  function M.handleWorldStoppedMoving()
    stopMoving = true
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

  -- Release the moon
  function M.release()
    if not M.initialized then
      return
    end

    graphic.release()

    M.initialized = false
    M.destroyed = true
    stopMoving = false
  end

  return M
end

return moonComplete
