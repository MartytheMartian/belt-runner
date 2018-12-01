local Reader = require("game.reader")
local World = require("game.world")

local Game = {}

-- Flags
local paused = false

-- Events
local endEvent = nil

-- Update the game
local function update()
  -- Update the world if not paused
  if not paused then
    World.update()
  end
end

-- Handle touch events
local function touch(event)
  -- Let the world handle it if not paused
  if not paused then
    World.touch(event.x, event.y)
  end
end

-- Exit the game
local function exit()
  -- Release the world and fire the end event
  World.release()
  endEvent()
end

-- Initializes the game with a target level and end event hook
function Game.load(file, eEnd)
  -- Track events
  endEvent = eEnd

  -- Read the level
  local level = Reader(file)

  -- Initialize the world with the map
  World.initialize(level, exit)
end

-- Starts the loaded level
function Game.start()
  -- Render the game
  Runtime:addEventListener("enterFrame", update)

  -- Listen for user interaction
  Runtime:addEventListener("touch", touch)
end

-- Stops the level
function Game.stop()
  -- Remove events
  Runtime:removeEventListener("enterFrame", update)
  Runtime:removeEventListener("touch", touch)
end

-- Destroys the level
function Game.destroy()
  -- Clear out world resources
  World.release()
end

return Game
