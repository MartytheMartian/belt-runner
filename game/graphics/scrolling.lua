-- Creates an instance of a 'scrolling' generator
function generator(graphic)
  -- Extract required properties
  local id = graphic.id
  local path = graphic.path
  local width = graphic.width
  local height = graphic.height

  if path == nil then
    error("Scrollings cannot have a nil path")
  end

  if width == nil then
    error("Scrollings cannot have a nil width")
  end

  if height == nil then
    error("Scrollings cannot have a nil height")
  end

  -- Create an instance of a 'scrolling'
  function create(entity)
    -- Return instance
    local M = {type = "scrolling"}

    if entity.x == nil then
      error("Scrollings cannot have a nil x position")
    end

    if entity.y == nil then
      error("Scrollings cannot have a nil y position")
    end

    -- Sprites to use
    local sprite1 = nil
    local sprite2 = nil
    local sprite3 = nil

    -- Initialize the scrolling
    function M.initialize()
      -- Initialize the sprites
      sprite1 = display.newImageRect(path, width, height)
      sprite2 = display.newImageRect(path, width, height)
      sprite3 = display.newImageRect(path, width, height)

      -- Set the starting points
      sprite1.x = entity.x
      sprite1.y = entity.y
      sprite2.x = sprite1.x + width
      sprite2.y = entity.y
      sprite3.x = sprite2.x + width
      sprite3.y = entity.y
    end

    -- Get current position
    function M.position()
      return {
        x = entity.x,
        y = entity.y
      }
    end

    -- Get size
    function M.size()
      return {
        width = width,
        height = height
      }
    end

    -- Move the sprite
    function M.move(x, y)
      -- Do nothing for scrollings
    end

    -- Scroll the sprite
    function M.scroll(scrollX, scrollY)
      -- Update each sprite
      sprite1.x = sprite1.x + scrollX
      sprite2.x = sprite2.x + scrollX
      sprite3.x = sprite3.x + scrollX

      -- Reset the first sprite if necessary
      if sprite1.x < -667 then
        sprite1.x = 3335
      end

      -- Reset the second sprite if necessary
      if sprite2.x < -667 then
        sprite2.x = 3335
      end

      -- Reset the third sprite if necessary
      if sprite3.x < -667 then
        sprite3.x = 3335
      end
    end

    -- Release the scrolling
    function M.release()
      -- Clear out sprite 1
      if sprite1 ~= nil then
        sprite1:removeSelf()
        sprite1 = nil
      end

      -- Clear out sprite 2
      if sprite2 ~= nil then
        sprite2:removeSelf()
        sprite2 = nil
      end

      -- Clear out sprite 3
      if sprite3 ~= nil then
        sprite3:removeSelf()
        sprite3 = nil
      end
    end

    return M
  end

  return create
end

return generator
