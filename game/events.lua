Events = {}

Events.speed = false
Events.kill = false
local world = nil
local resources = nil
local speedFrame = 0
local killFrame = 0

-- Use hook method for injection to break circular dependencies
function Events.hook(w, r)
  world = w
  resources = r
end

-- Fires a 'playerDied' event
function Events.playerDied()
  -- Stop the world
  world.stop()

  -- Stop all entities
  for i, entity in ipairs(resources.entities) do
    repeat
      -- Ignore dead or uninitialized
      if not entity.initialized or entity.destroyed then
        break
      end

      -- Stop
      entity:stop()
    until true
  end

  -- Inform the world after three seconds
  timer.performWithDelay(3000, world.playerDied)
end

-- Fires a 'killAll' event
function Events.killAll()
  -- Trigger flag
  kill = true
end

-- Fires a 'fasterEnemies' event
function Events.fasterEnemies()
  -- Flip the "fast" flag
  Events.speed = true
end

-- Fires a lurcher event
function Events.lurcher(crate)
  -- Get the lurcher
  local lurcher = resources.getEntityByID(crate.lurcherId)

  -- Attack
  lurcher:attack()
end

-- Update for event flags
function Events.update()
  -- Reset flags
  if kill then
    if killFrame > 1 then
      kill = false
    else
      killFrame = killFrame + 1
    end
  end

  -- Reset speed when necessary
  if Events.speed then
    if speedFrame > 180 then
      Events.speed = false
    else
      speedFrame = speedFrame + 1
    end
  end
end

return Events
