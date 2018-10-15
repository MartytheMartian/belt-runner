local common = require("common")

-- The asset used by the asteroid
local image = nil

-- Supported sequences
local sequences = {
  {
    name = "floating",
    start = 1,
    count = 64,
    time = 2400,
    loopCount = 0,
    loopDirection = "forward"
  },
  {
    name = "exploding",
    start = 65,
    count = 16,
    time = 1000,
    loopCount = 1,
    loopDirection = "forward"
  }
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
  local exploding = false

  -- Initializes the asteroid to the screen
  function M.initialized()
    -- Back out if already active
    if active then
      return true
    end

    -- Back out if not on the screen
    if common.onScreen(x, y, asset.width, asset.height) then
      -- Move the spawn point over until initialization occurs
      x = x - 10
      y = y
      return false
    end

    -- Setup the sprite
    sprite = display.newSprite(image, sequences)
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
      -- Move
      sprite.x = sprite.x - 10
      sprite.y = sprite.y

      -- Explode if necessary
      if sprite.x < 1000 and not exploding then
        exploding = true
        sprite:setSequence("exploding")
        sprite:play()
      end
    end
  end

  -- Convert props as necessary
  asset.width = tonumber(asset.width)
  asset.height = tonumber(asset.height)

  -- Load the image
  load(asset)
  return M
end

return asteroid
