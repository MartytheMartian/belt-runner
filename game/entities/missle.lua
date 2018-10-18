local collision = require("game.collision")

-- Create a missle
function missle(properties, graphic)
  local M = {}

  M.id = properties.id
  M.type = "missle"
  M.initialized = false
  M.destroyed = false
  M.collidable = true
  M.shape = "circle"

  -- Initialize the missle
  function M.initialize()
    if M.initialized then
      return
    end

    graphic.initialize()
    graphic.rotate(properties.rotation)

    M.initialized = true
    M.destroyed = false
    M.collidable = true
  end

  -- Update the missle
  function M.update()
    if not M.initialized or M.destroyed then
      return
    end

    -- Destroy if off-screen
    local size = graphic.size()
    if not collision.onScreen(properties.x, properties.y, size.width, size.height) then
      M.destroyed = true
      M.collidable = false
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

    -- Append radius
    local size = graphic.size()
    size.radius = size.width / 2

    return size
  end

  -- Called when the missle has collided with something
  function M.collided(entity)
    if entity.type == "asteroid" then
      M.destroyed = true
      M.collidable = false
    end
  end

  -- Release the missle
  function M.release()
    if not M.initialized then
      return
    end

    graphic.release()

    M.initialized = false
  end

  return M
end

return missle
