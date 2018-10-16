-- The asset used by the background
local image = nil

-- Sequence data
local sequenceData = {
  name = "visible",
  frames = {1}
}

-- Used to initialize constant background variables
local function load()
  local options = {
    width = 1334,
    height = 750,
    numFrames = 1,
    sheetContentWidth = 1334,
    sheetContentHeight = 750
  }

  -- Load the image
  image = graphics.newImageSheet("assets/background.png", options)
end

-- Constructor for a new background
function background()
  -- Return instance
  local M = {}

  -- Local variables
  local sprite = nil

  -- Initializes the background to the screen
  function M.initialized()
    -- Back out if already active
    if active then
      return true
    end

    -- Setup the sprite
    sprite = display.newSprite(image, sequenceData)
    sprite.x = 667
    sprite.y = 375
    active = true
    return true
  end

  -- Update the background
  function M.update()
    if M.initialized() then
    end
  end

  -- Load the image
  load()

  -- Set accessible properties
  M.type = "background"

  return M
end

return background
