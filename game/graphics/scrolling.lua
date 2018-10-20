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

    -- Sprite to use
    local sprite = nil

    -- Initialize the scrolling
    function M.initialize()
      -- Initialize the sprite
      sprite = display.newRect(entity.x, entity.y, width, height)

      -- Set the sprite image
      sprite.fill = {type = "image", filename = path}
    end

    -- Get current position
    function M.position()
      -- No position if there is no sprite
      if sprite == nil then
        error("Cannot get position of a scrolling if it has not been drawn yet")
      end

      return {
        x = sprite.x,
        y = sprite.y
      }
    end

    -- Get size
    function M.size()
      if sprite == nil then
        error("Cannot get position of a scrolling if it has not been drawn yet")
      end

      return {
        width = width,
        height = height
      }
    end

    -- Move the sprite
    function M.move(x, y)
      sprite.x = x
      sprite.y = y
    end

    -- Scroll the sprite
    function M.scroll(time, scrollX, scrollY)
      transition.to(sprite.fill, {time = time, x = sprite.fill.x + scrollX, iterations = -1})
    end

    -- Release the scrolling
    function M.release()
      -- Clear out the sprite and set it to nothing
      sprite:removeSelf()
      sprite = nil
    end

    return M
  end

  return create
end

return generator
