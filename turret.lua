-- The asset used by the turret
local image = nil

-- Sequence data for the "alive" state
local alive = {
  name = "alive",
  start = 1,
  count = 1,
  time = 2400,
  loopCount = 0,
  loopDirection = "bounce"
}

-- Used to initialize constant turret variables
local function load()
  -- Load in the asset if it hasn't been loaded yet
  if image == nil then
    local options = {
      width = 54,
      height = 37,
      numFrames = 1,
      sheetContentWidth = 54,
      sheetContentHeight = 37
    }

    -- Load the image
    image = graphics.newImageSheet("assets/turret.png", options)
  end
end

-- Constructor for a new turret
function turret()
  -- Return instance
  local M = {}

  -- Local variables
  local sprite = nil
  local active = false

  -- Initializes the turret to the screen
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

  -- Update the turret
  function M.update()
    if M.initialized() then
    end
  end

  -- Rotate the turret
  function M.rotate(rotation)
    sprite.rotation = rotation
  end

  -- Kill the turret
  function M.kill()
    sprite:removeSelf()
  end

  -- Load the image
  load()

  -- Set accessible properties
  M.type = "turret"

  return M
end

return turret
