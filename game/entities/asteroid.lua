-- Create a asteroid
function asteroid(properties, graphic)
  local M = {}

  M.id = properties.id
  M.type = "asteroid"
  M.initialized = false
  M.collidable = true
  M.shape = "circle"

  local exploding = false

  -- Initialize the asteroid
  function M.initialize()
    if M.initialized then
      return
    end

    graphic.initialize("floating")

    M.initialized = true
  end

  -- Update the asteroid
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
      graphic.rotate(10)
    end

    -- Move it
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

    -- Append radius
    local size = graphic.size()
    size.radius = size.width / 2

    return size
  end

  -- Called when the asteroid has collided with something
  function M.collided(entity)
    -- Only care if the entity is a player or missle
    if entity.type ~= "player" and entity.type ~= "missle" then
      return
    end
    
    -- No longer collidable
    M.collidable = false

    -- Explode
    graphic.setSequence("exploding")

    -- Mark as exploded
    exploding = true
  end

  -- Release the asteroid
  function M.release()
    if not M.initialized then
      return
    end

    graphic.release()

    M.initialized = false
  end

  return M
end

return asteroid
