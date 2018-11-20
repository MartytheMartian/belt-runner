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
  local isDying = false;
  local isPullingPlayerIntoHole = false
  local hitPoints = 3;

  M.id = properties.id
  M.type = "tentacle"
  M.initialized = false
  M.collidable = true
  M.destroyed = false
  M.shape = "rectangle"

  -- Initialize the tentacle
  function M.initialize()
      if M.initialized then
        return
      end
  
      graphic.initialize("attacking")
  
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

        -- Handle dying, e.g. retract into hole
        if ((isDying or isPullingPlayerIntoHole) and position.y <= 1070) then
          properties.vY = 4.5
        elseif (isDying and position.y == 2000) then
          graphic.move(position.x, 2000)
          M.destroyed = true;
        elseif (isPullingPlayerIntoHole and position.y == 2000) then
          -- TODO: Do something here when tentacle has fully dragged player into hole
          M.destroyed = true;
        else
          -- Move the tentacle towards the player if it nears the player
          if position.x <= 1350 and position.y >= 505 then
            properties.vY = -3.2
          else
            properties.vY = 0
          end
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
        else
          graphic.move(position.x, position.y + properties.vY)
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
    --print(entity.type);

    if(entity.type == "player") then
      graphic.setSequence("killing")
      isPullingPlayerIntoHole = true;
      M.collidable = false
    elseif(entity.type == "missle") then
      if(hitPoints > 1) then
        doInjuredFlicker()
        hitPoints = hitPoints - 1
        -- Play tentacle hit sound
        --gameAudio.playBasicExplosionSound()
        print("Tentacle hitpoints: " .. hitPoints)
      else
        doInjuredFlicker()
        -- Play tentacle critically injured and retracting sound
        --gameAudio.playBasicExplosionSound()
        isDying = true;
        M.collidable = false;
        print("Tentacle dying")
      end
    end

  end

  function doInjuredFlicker()
        graphic.setFillColor(1, 0, 0, 0.8)
        timer.performWithDelay(50, function() graphic.setFillColor(1, 1, 1, 1.0) end)
        timer.performWithDelay(100, function() graphic.setFillColor(1, 0, 0, 0.8) end)
        timer.performWithDelay(150, function() graphic.setFillColor(1, 1, 1, 1.0) end)
        timer.performWithDelay(200, function() graphic.setFillColor(1, 0, 0, 0.8) end)
        timer.performWithDelay(250, function() graphic.setFillColor(1, 1, 1, 1.0) end)
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
