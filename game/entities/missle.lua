local collision = require("game.collision")
local gameAudio = require("game.sounds")

-- Entities that this entity can collide with
local collidableEntities = {
  asteroid = true,
  alien = true,
  debris = true
}

-- Create a missle
function missle(properties, graphic)
  local M = {}

  M.id = properties.id
  M.type = "missle"
  M.initialized = false
  M.collidable = false
  M.destroyed = false
  M.shape = "rectangle"

  -- Initialize the missle
  function M.initialize()
    if M.initialized then
      return
    end

    -- Initialize the entity but make sure it isn't 'active' yet
    -- Missles get handled differently
    M.collidable = false
    M.initialized = true
    M.destroyed = true
  end

  -- Spawn the missle into the world
  function M.spawn(x, y, vX, vY, rotation)
    if not M.initialized then
      return
    end

    -- Reset the velocity and rotation
    properties.vX = vX
    properties.vY = vY
    properties.rotation = rotation

    -- Initialize the missle and set its position
    graphic.initialize()
    graphic.move(x, y)

    -- Rotate the missle
    graphic.rotate(rotation)

    -- Set flags
    M.initialized = true
    M.collidable = true
    M.destroyed = false

    -- Play missile firing audio on spawn
    gameAudio.playMissleSound()
  end

  -- Update the missle
  function M.update()
    if not M.initialized or M.destroyed then
      return
    end

    -- Get the position
    local position = graphic.position()

    -- Destroy if off-screen
    local size = graphic.size()
    if not collision.onScreen(position.x, position.y, size.width, size.height) then
      M.collidable = false
      M.destroyed = true
      return
    end

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

    -- Append radius
    local size = graphic.size()
    size.radius = size.width / 2

    return size
  end

  -- Is the entity collidable right now
  function M.canCollide(type)
    if not M.collidable then
      return false
    end

    return collidableEntities[type] ~= nil
  end

  -- Called when the missle has collided with something
  function M.collided(entity)
    -- Flag as destroyed
    M.collidable = false
    M.destroyed = true

    -- Play explosion
    gameAudio.playBasicExplosionSound()

    -- Move off screen
    graphic.move(-32, -32)
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
