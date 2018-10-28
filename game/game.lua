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

-- Loads the target level
function M.load(file)
  -- Read the level
  local level = read(file)

  -- Initialize the world with the map
  world.initialize(level)
end

-- Starts the loaded level
function M.start()
  -- Start playing background music
  gameAudio.playBackgroundMusic()

  -- Render the game
  Runtime:addEventListener("enterFrame", update)

  -- Listen for user interaction
  Runtime:addEventListener("touch", touch)
end

-- Stops the level
function M.stop()
  -- Remove events
  Runtime:removeEventListener("enterFrame", update)
  Runtime:removeEventListener("touch", touch)
end

-- Destroys the level
function M.destroy()
  -- Clear out world resources
  world.release()
end

return M
