-- Create a nebula
function nebula(properties, graphic)
  local M = {}

  M.id = properties.id
  M.type = "nebula"
  M.initialized = false
  M.collidable = false
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

    graphic.move(properties.vX, properties.vY)
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
  end

  return M
end

return nebula
