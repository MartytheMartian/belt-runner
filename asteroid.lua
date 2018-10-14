-- The asset used by the asteroid
local image = nil

-- Sequence data for the "floating" state
local floating = {
  name = "floating",
  start = 1,
  count = 64,
  time = 2400,
  loopCount = 0,
  loopDirection = "bounce"
}

-- Used to initialize constant asteroid variables
local function load(asset)
  -- Load in the asset if it hasn't been loaded yet
  if image == nil then
    local options = {
      width = asset.width,
      height = asset.height,
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

  -- Local variables
  local sprite = nil
  local x = tonumber(properties.x)
  local y = tonumber(properties.y)
  local active = false

  -- Initializes the asteroid to the screen
  function M.initialized()
    -- Back out if already active
    if active then
      return true
    end

    -- Back out if not on the screen
    if x > 1334 or x < 0 or y > 750 or y < 0 then
      -- Move the spawn point over until initialization occurs
      x = x - 10
      return false
    end

    -- Setup the sprite
    sprite = display.newSprite(image, floating)
    sprite.x = x
    sprite.y = y
    active = true

    -- Start animation
    sprite:play()

    return true
  end

  -- Update the asteroid
  function M.update()
    -- Update the asteroid if initialized
    if M.initialized() then
      sprite.x = sprite.x - 10
    end
  end

  -- Load the image
  load(asset)
  return M
end

return asteroid
