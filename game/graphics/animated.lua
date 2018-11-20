-- Creates an instance of a 'animated' generator
function generator(graphic)
  if graphic.path == nil then
    error("Animateds cannot have a nil path")
  end

  if graphic.width == nil then
    error("Animateds cannot have a nil width")
  end

  if graphic.height == nil then
    error("Animateds cannot have a nil height")
  end

  if graphic.numFrames == nil then
    error("Animateds cannot have a nil numFrames")
  end

  if graphic.sheetContentWidth == nil then
    error("Animateds cannot have a nil sheetContentWidth")
  end

  if graphic.sheetContentHeight == nil then
    error("Animateds cannot have a nil sheetContentHeight")
  end

  if graphic.sequences == nil then
    error("Animateds cannot have a nil sequences")
  end

  local options = {
    width = graphic.width,
    height = graphic.height,
    numFrames = graphic.numFrames,
    sheetContentWidth = graphic.sheetContentWidth,
    sheetContentHeight = graphic.sheetContentHeight
  }

  local image = graphics.newImageSheet(graphic.path, options)

  -- Create an instance of a 'animated'
  function create(entity)
    -- Return instance
    local M = {type = "animated"}

    if entity.x == nil then
      error("Animateds cannot have a nil x position")
    end

    if entity.y == nil then
      error("Animateds cannot have a nil y position")
    end

    -- Sprite to use
    local sprite = nil

    -- Initialize the animated
    function M.initialize()
      -- Create the sprite
      sprite = display.newSprite(image, graphic.sequences)

      -- Set the initial position
      sprite.x = entity.x
      sprite.y = entity.y

      -- Start the animation
      sprite:play()
    end

    -- Get current position
    function M.position()
      if sprite == nil then
        error("Cannot get position of a animated if it has not been drawn yet")
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
        error("Cannot get position of a animated if it has not been drawn yet")
      end

      return {
        width = graphic.width,
        height = graphic.height
      }
    end

    -- Move the sprite
    function M.move(x, y)
      if sprite == nil then
        error("Cannot move an animated sprite if it has not been drawn yet")
      end

      sprite.x = x
      sprite.y = y
    end

    -- Rotate the sprite
    function M.rotate(rotation)
      sprite.rotation = rotation
    end

    -- Update the animation
    function M.setSequence(sequence)
      if sprite == nil then
        error("Cannot swap the sequence of an animated sprite if it has not been drawn yet")
      end

      sprite:setSequence(sequence)
      sprite:play()
    end

    function M.setFillColor(r, g, b, a)
      return sprite:setFillColor(r, g, b, a)
    end

    -- Release the animated
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
