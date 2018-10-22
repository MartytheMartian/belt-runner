local read = require("game.reader")
local world = require("game.world")
local gameAudio = require("game.sounds")

local M = {}

local paused = false

-- Update the game
local function update()
  -- Update the world if not paused
  if not paused then
    world.update()
  end
end

-- Handle touch events
local function touch(event)
  -- Let the world handle it if not paused
  if not paused then
    world.touch(event.x, event.y)
  end
end

-- Exit the game
local function exit()
  -- Release the world
  world.release()
end

-- Start the target level
function M.start(file)
  -- Read the level
  local level = read(file)

  -- Initialize the world with the map
  world.initialize(level)

  -- Start playing background music
  gameAudio.playBackgroundMusic()

  -- Render the game
  Runtime:addEventListener("enterFrame", update)

  -- Listen for user interaction
  Runtime:addEventListener("touch", touch)
end

return M
