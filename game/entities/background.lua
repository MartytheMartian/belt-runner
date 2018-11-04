-- Create a background
function background(properties, graphic)
  local M = {}
  local stopMoving = false;

  M.id = properties.id
  M.type = "background"
  M.initialized = false
  M.collidable = false
  M.shape = "rectangle"

  -- Initialize the background
  function M.initialize()
    if M.initialized then
      return
    end

    -- Initialize
    graphic.initialize()

    M.initialized = true
  end

  -- Update the background
  function M.update()
    if not M.initialized then
      return
    end

    if not stopMoving then
      graphic.scroll(properties.vX)
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

  -- Release the background
  function M.release()
    if not M.initialized then
      return
    end

    graphic.release()

    M.initialized = false
    stopMoving = false
  end

  return M
end

return background
