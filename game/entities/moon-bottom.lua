-- This is the bottom half of the moon that houses a tentacle

-- Entities that this entity can collide with
local collidableEntities = {
}

-- Create a moon bottom portion
function moonBottom(properties, graphic)

  local M = {}

  M.id = properties.id
  M.type = "moonBottom"
  M.initialized = false
  M.collidable = false
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

  -- Update the moon portion
  function M.update()
      if not M.initialized then
          return
        end
    
        -- Get the position and size
        local position = graphic.position()
        local size = graphic.size()
    
        -- Release the moon if off screen
        -- TODO: we may not want to actually release mid level. Might want to wait to clean up at end of level
        if position.x + size.width <= 0 then
          M.release()
          return
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

-- Release the turret
function M.release()
  if not M.initialized then
    return
  end

  graphic.release()

  M.initialized = false
  M.destroyed = true
end

return M
end

return moonBottom

