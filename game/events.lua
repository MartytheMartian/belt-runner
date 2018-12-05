Events = {}

Events.speed = false
Events.kill = false
Events.stopped = false
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
  -- Set the stopped flag
  Events.stopped = true

  -- Destroy turret
  resources.getEntityByID("turret"):release()

  -- Stop the world
  world.stop()

  -- Inform the world after three seconds
  timer.performWithDelay(3000, world.playerDied)
end

-- Fires a 'killAll' event
function Events.killAll()
  -- Trigger flag
  Events.kill = true
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

-- Processes any kill event
function Events.processKill(entity)
  if Events.kill then
    entity:killAll()
  end
end

-- Processes any necessary speed changes
function Events.processSpeed(entity)
  -- Do nothing if exploding
  if entity.exploding then
    return
  end

  -- Needs to go fast
  if Events.speed and not entity.speed then
    entity.speed = true
    entity:fast()
    return
  end

  if not Events.speed and entity.speed then
    entity.speed = false
    entity:resetSpeed()
    return
  end
end

-- Update for event flags
function Events.update()
  -- Reset flags
  if Events.kill then
    if killFrame > 1 then
      Events.kill = false
    else
      killFrame = killFrame + 1
    end
  end

  -- Reset speed when necessary
  if Events.speed then
    if speedFrame > 120 then
      Events.speed = false
    else
      speedFrame = speedFrame + 1
    end
  end
end

return Events
