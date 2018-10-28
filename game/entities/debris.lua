local gameAudio = require("game.sounds")

-- Entities that this entity can collide with
local collidableEntities = {
  missle = true,
  player = true
}

-- Create a debris
function debris(properties, graphic)
  local M = {}

  M.id = properties.id
  M.type = "debris"
  M.initialized = false
  M.collidable = false
  M.destroyed = false
  M.exploding = false
  M.shape = "rectangle"

  -- Initialize the debris
  function M.initialize()
    if M.initialized then
      return
    end

    graphic.initialize("floating")

    M.collidable = true
    M.initialized = true
    M.exploding = false
    M.destroyed = false
  end

  -- Update the debris
  function M.update()
    if not M.initialized then
      return
    end

    -- Check the current position
    local position = graphic.position()

    -- Slowly decrease velocity if exploding
    if M.exploding then
      properties.vX = properties.vX * .95
      properties.vY = properties.vY * .95
    end

    -- Move it
    graphic.move(position.x + properties.vX, position.y + properties.vY)
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

  -- Is the entity collidable right now
  function M.canCollide(type)
    if not M.collidable then
      return false
    end

    return collidableEntities[type] ~= nil
  end

  -- Called when the debris has collided with something
  function M.collided(entity)
    -- Disable colliding
    M.collidable = false

    -- Start exploding
    graphic.setGraphic("exploding")
    M.exploding = true

    -- Play debris explosion sound
    gameAudio.playBasicExplosionSound()
  end

  -- Release the debris
  function M.release()
    if not M.initialized then
      return
    end

    graphic.release()

    M.initialized = false
  end

  return M
end

return debris
