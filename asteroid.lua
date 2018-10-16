local common = require("common")

-- The asset used by the asteroid
local image = nil
local w = nil
local h = nil
local r = nil

-- Supported sequences
local sequences = {
  {
    name = "floating",
    start = 1,
    count = 32,
    rotation = 100,
    time = 1200,
    loopCount = 0,
    loopDirection = "forward"
  },
  {
    name = "exploding",
    start = 32,
    count = 17,
    time = 1000,
    loopCount = 1,
    loopDirection = "forward"
  }
}

-- Used to initialize constant asteroid variables
local function load(asset)
  -- Load in the asset if it hasn't been loaded yet
  if image == nil then
    w = tonumber(asset.width)
    h = tonumber(asset.height)
    r = w / 2 - 15

    local options = {
      width = w,
      height = h,
      numFrames = asset.numFrames,
      sheetContentWidth = asset.sheetContentWidth,
      sheetContentHeight = asset.sheetContentHeight
    }

    -- Load the image
    image = graphics.newImageSheet(asset.path, options)
  end
end

-- Constructor for a new asteroid
function asteroid(asset, properties)
  -- Return instance
  local M = {}

  -- 'Public' properties
  M.type = "asteroid"
  M.active = false

  local sprite = nil
  local vX = tonumber(properties.vX)
  local vY = tonumber(properties.vY)
  local delay = tonumber(properties.delay)
  local exploding = false

  -- Initializes the asteroid to the screen
  function M.initialized()
    -- Back out if already active
    if M.active or exploding then
      return true
    end

    -- Back out if the delay has not been reached
    if common.frames < delay then
      return false
    end

    -- Setup the sprite
    sprite = display.newSprite(image, sequences)
    sprite.x = properties.x
    sprite.y = properties.y
    M.active = true

    -- Randomize the start frame for each asteroid
    sprite:setFrame(math.random(1, 32))

    -- Start animation
    sprite:play()

    return true
  end

  -- Update the asteroid
  function M.update()
    -- Update the asteroid if initialized
    if M.initialized() then
      -- Move
      sprite.x = sprite.x + vX
      sprite.y = sprite.y + vY

      if exploding then
        -- Decrease velocity gradually
        if vX ~= 0 then
          vX = vX * .95
        end

        if vY ~= 0 then
          vY = vY * .95
        end
      else
        -- Reset rotation
        if sprite.rotation > 360 then
          sprite.rotation = 0
        end

        -- Increment rotation
        sprite.rotation = sprite.rotation + 10
      end
    end
  end

  -- Get position
  function M.position()
    return {
      x = sprite.x,
      y = sprite.y
    }
  end

  -- Get size
  function M.size()
    return {
      x = sprite.x,
      y = sprite.y,
      w = w,
      h = h,
      r = r
    }
  end

  -- Kill
  function M.kill()
    -- Update flags
    M.active = false
    exploding = true

    -- Update to exploding
    sprite:setSequence("exploding")
    sprite:play()
  end

  -- Load the image
  load(asset)

  return M
end

return asteroid
