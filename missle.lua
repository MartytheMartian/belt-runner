local common = require("common")

-- The asset used by the missle
local image = nil
local w = 32
local h = 32

-- Supported sequences
local sequences = {
  {
    name = "flying",
    start = 1,
    count = 3,
    time = 400,
    loopCount = 0,
    loopDirection = "forward"
  }
}

-- Used to initialize constant missle variables
local function load()
  -- Load in the asset if it hasn't been loaded yet
  if image == nil then
    local options = {
      width = w,
      height = h,
      numFrames = 4,
      sheetContentWidth = 32,
      sheetContentHeight = 128
    }

    -- Load the image
    image = graphics.newImageSheet("assets/fireball.png", options)
  end
end

-- Constructor for a new missle
function missle(properties)
  -- Return instance
  local M = {}

  -- Set accessible properties
  M.type = "missle"

  -- Local variables
  local sprite = nil
  local vX = properties.vX
  local vY = properties.vY
  local active = false
  local dead = false

  -- Initializes the missle to the screen
  function M.initialized()
    -- Back out if already active
    if active then
      return true
    end

    -- Back out if dead
    if dead then
      return false
    end

    -- Setup the sprite
    sprite = display.newSprite(image, sequences)
    sprite.x = properties.x
    sprite.y = properties.y
    sprite.rotation = properties.rotation
    active = true

    -- Start animation
    sprite:play()

    return true
  end

  -- Update the missle
  function M.update()
    -- Update the missle if initialized
    if M.initialized() then
      -- Move
      sprite.x = sprite.x + vX
      sprite.y = sprite.y + vY

      -- Check for collisions
      for i, entity in ipairs(common.entities) do
        repeat
          -- Ignore non-asteroids
          if entity.type ~= "asteroid" then
            break
          end

          -- Ignore dead asteroids
          if not entity.active then
            break
          end

          -- Is colliding with asteroid
          local colliding = common.circleCollision(M, entity)

          -- Kill the asteroid and the missle on impact
          if colliding then
            entity.kill()
            M.kill()
          end
        until true
      end
    end
  end

  -- Kill the missile
  function M.kill()
    -- Set flags
    dead = true
    active = false

    -- Hide the sprite
    sprite:removeSelf()
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
      w = w,
      h = h
    }
  end

  -- Load the image
  load()

  return M
end

return missle
