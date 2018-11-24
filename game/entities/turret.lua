-- Create a turret
function turret(properties, graphic)
  local M = {}

  M.id = properties.id
  M.type = "turret"
  M.initialized = false
  M.collidable = false
  M.destroyed = false
  M.shape = "rectangle"

  -- Initialize the turret
  function M.initialize()
    if M.initialized then
      return
    end

    graphic.initialize()

    M.initialized = true
  end

  -- Update the turret
  function M.update()
    -- Only here to satisfy entity requirements
  end

  -- Do anything that needs to be done if the world has stopped moving
  function M.handleWorldStoppedMoving()
    -- NOTE: Making assumption here that if the world stops we want the main player (or turret)
    --       graphic to disappear because a death animation or such from another asset will take over
    graphic.release()
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

  -- Rotate the turret
  function M.rotate(rotation)
    if not M.initialized then
      return
    end

    graphic.oneRotation(rotation)
  end

  -- Release the turret
  function M.release()
    if not M.initialized then
      return
    end

    graphic.release()

    M.initialized = false
    M.destroyed = true
  end

  return M
end

return turret
