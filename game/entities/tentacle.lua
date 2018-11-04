-- This is the tentacle that comes out of the moon

local gameAudio = require("game.sounds")

-- Entities that this entity can collide with
local collidableEntities = {
  missle = true,
  player = true
}

-- Create a tentacle
function tentacle(properties, graphic)

  local M = {}
  local stopMoving = false

  M.id = properties.id
  M.type = "tentacle"
  M.initialized = false
  M.collidable = true
  M.destroyed = false
  M.shape = "rectangle"

  -- Initialize the moon
  function M.initialize()
      if M.initialized then
        return
      end
  
      graphic.initialize()
  
      M.initialized = true
    end

  -- Update the tentacle
  function M.update()
      if not M.initialized then
          return
        end
    
        -- Get the position and size
        local position = graphic.position()
        local size = graphic.size()

        -- Move the tentacle towards the player if it nears the player
        if position.x <= 790 and position.y >= 405 then
          properties.vY = -3
        else
          properties.vY = 0
        end
    
        -- Release the tentacle if off screen
        -- TODO: we may not want to actually release mid level. Might want to wait to clean up at end of level
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

  -- Can collide with a given entity
  function M.canCollide(type)
    if not M.collidable then
      return false
    end

    return collidableEntities[type] ~= nil
  end

  -- Called when the tentacle has collided with something
  function M.collided(entity)

    -- TODO: When collided with a missile, it will be momentarily stunned
    --       If colliding with player, world movement stops and the player gets pulled into the moon

    -- Disable colliding
    --M.collidable = false

    -- Start exploding
    --graphic.setGraphic("exploding")

    -- Play tentacle hit sound
    --gameAudio.playBasicExplosionSound()

    -- Flag as dead
    --M.destroyed = true
  end

  -- Release the tentacle
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

return tentacle
