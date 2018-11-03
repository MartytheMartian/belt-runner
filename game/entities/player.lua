local gameAudio = require("game.sounds")

-- Entities that this entity can collide with
local collidableEntities = {
  asteroid = true,
  alien = true,
  debris = true
}

-- Create a player
function player(properties, graphic)
  local M = {}

  M.id = properties.id
  M.type = "player"
  M.initialized = false
  M.collidable = false
  M.destroyed = false
  M.shape = "rectangle"

  -- Events the player can trigger
  local died = nil

  -- Initialize the player
  function M.initialize()
    if M.initialized then
      return
    end

    graphic.initialize("alive")

    M.collidable = true
    M.initialized = true
    M.destroyed = false
  end

  -- Update the player
  function M.update()
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
    if not M.collidable or true then
      return false
    end

    return collidableEntities[type] ~= nil
  end

  -- Called when the player has collided with something
  function M.collided(entity)
    -- Disable colliding
    M.collidable = false

    -- Start exploding
    graphic.setGraphic("exploding")

    -- Play player explosion sound
    gameAudio.playBasicExplosionSound()

    -- Flag as dead
    M.destroyed = true

    -- Trigger death handler if necessary
    if died ~= nil then
      died()
    end
  end

  -- Called to register the event for death
  function M.setDiedHandler(handler)
    if type(handler) ~= "function" then
      error("Died handler must be a function")
    end

    died = handler
  end

  -- Release the player
  function M.release()
    if not M.initialized then
      return
    end

    graphic.release()

    M.initialized = false
  end

  return M
end

return player
