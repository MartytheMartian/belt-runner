-- Create a turret
function turret(properties, graphic)
  local M = {}

  M.id = properties.id
  M.type = "turret"
  M.initialized = false
  M.collidable = false
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

    graphic.rotate(rotation)
  end

  -- Release the turret
  function M.release()
    if not M.initialized then
      return
    end

    graphic.release()

    M.initialized = false
  end

  return M
end

return turret
