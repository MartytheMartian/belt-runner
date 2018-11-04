-- Create a nebula
function nebula(properties, graphic)
  local M = {}

  local stopMoving = false

  M.id = properties.id
  M.type = "nebula"
  M.initialized = false
  M.collidable = false
  M.destroyed = false
  M.shape = "rectangle"

  -- Initialize the nebula
  function M.initialize()
    if M.initialized then
      return
    end

    graphic.initialize()

    M.initialized = true
  end

  -- Update the nebula
  function M.update()
    if not M.initialized then
      return
    end

    -- Get the position and size
    local position = graphic.position()
    local size = graphic.size()

    -- Release the nebula if off screen
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
    stopMoving = true;
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

  -- Release the nebula
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

return nebula
