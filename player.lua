local common = require("common")

-- The asset used by the player
local image = nil
local explosionImage = nil

-- Sequence data for the "alive" state
local sequenceData = {}

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

    local explosionOptions = {
      width = 100,
      height = 100,
      numFrames = 16,
      sheetContentWidth = 800,
      sheetContentHeight = 200
    }

    -- Load the image
    image = graphics.newImageSheet("assets/player.png", options)
    explosionImage = graphics.newImageSheet("assets/explosion.png", explosionOptions)

    -- Initialize sequence data
    sequenceData = {
      {name = "alive", sheet = image, start = 1, count = 1, time = 1, loopCount = 0},
      {name = "exploding", sheet = explosionImage, start = 1, count = 16, time = 1000, loopCount = 1}
    }
  end
end

-- Constructor for a new player
function player()
  -- Return instance
  local M = {}

  -- Local variables
  local sprite = nil
  local active = false
  local exploding = false

  -- Initializes the player to the screen
  function M.initialized()
    -- Back out if already active
    if active or exploding then
      return true
    end

    -- Setup the sprite
    sprite = display.newSprite(image, sequenceData)
    sprite.x = 667
    sprite.y = 375
    active = true

    return true
  end

  -- Update the player
  function M.update()
    if M.initialized() and not exploding then
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
          local colliding = common.rectToCircle(M, entity)

          -- Kill the asteroid, player, and turret on impact
          if colliding then
            entity.kill()
            M.kill()
            common.turret.kill()
          end
        until true
      end
    end
  end

  -- Kill the player
  function M.kill()
    -- Set flags
    active = false
    exploding = true

    -- Update to exploding
    sprite:setSequence("exploding")
    sprite:play()
  end

  -- Is the player alive
  function M.alive()
    return active and not exploding
  end

  -- Player's size
  function M.size()
    return {
      x = 667,
      y = 375,
      w = 123,
      h = 57
    }
  end

  -- Load the image
  load()

  -- Set accessible properties
  M.type = "player"

  return M
end

return player
