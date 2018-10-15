-- The asset used by the player
local image = nil

-- Sequence data for the "alive" state
local alive = {
  name = "alive",
  start = 1,
  count = 64,
  time = 2400,
  loopCount = 0,
  loopDirection = "bounce"
}

-- Used to initialize constant player variables
local function load()
  -- Load in the asset if it hasn't been loaded yet
  if image == nil then
    local options = {
      width = 133,
      height = 62,
      numFrames = 1,
      sheetContentWidth = 133,
      sheetContentHeight = 62
    }

    -- Load the image
    image = graphics.newImageSheet("assets/player.png", options)
  end
end

-- Constructor for a new asteroid
function player()
  -- Return instance
  local M = {}

  -- Local variables
  local sprite = nil
  local active = false

  -- Initializes the asteroid to the screen
  function M.initialized()
    -- Back out if already active
    if active then
      return true
    end

    -- Setup the sprite
    sprite = display.newSprite(image, alive)
    sprite.x = 667
    sprite.y = 375
    active = true

    return true
  end

  -- Update the player
  function M.update()
    if M.initialized() then
    end
  end

  -- Load the image
  load()
  return M
end

return player
