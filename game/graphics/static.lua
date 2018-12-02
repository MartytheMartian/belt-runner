-- Creates an instance of a 'static' generator
function generator(graphic)
  -- Extract required properties
  local id = graphic.id
  local path = graphic.path
  local width = graphic.width
  local height = graphic.height

  if path == nil then
    error("Statics cannot have a nil path")
  end

  if width == nil then
    error("Statics cannot have a nil width")
  end

  if height == nil then
    error("Statics cannot have a nil height")
  end

  -- Create an instance of a 'static'
  function create(entity)
    -- Return instance
    local M = {type = "static"}

    if entity.x == nil then
      error("Statics cannot have a nil x position")
    end

    if entity.y == nil then
      error("Statics cannot have a nil y position")
    end

    -- Sprite to use
    local sprite = nil

    -- Initialize the static
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
        error("Cannot get position of a static if it has not been drawn yet")
      end

      return {
        x = sprite.x,
        y = sprite.y,
        rotation = sprite.rotation
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

    -- Move to a location over a set time
    function M.moveTransition(params)
      transition.moveTo(sprite, params)
    end

    -- Rotate the sprite
    function M.rotate(rotation)
      sprite.rotation = sprite.rotation + rotation
    end

    -- Sets the rotation of the sprite
    function M.setRotation(rotation)
      sprite.rotation = rotation
    end

    function M.setFillColor(r, g, b, a)
      sprite:setFillColor(r, g, b, a)
    end

    -- Release the static
    function M.release()
      -- Clear out the sprite and set it to nothing
      if sprite ~= nil then
        sprite:removeSelf()
        sprite = nil
      end
    end

    return M
  end

  return create
end

return generator
