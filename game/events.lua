Events = {}

local world = nil
local resources = nil
local speed = false

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
      -- Stop everything
      entity:stop()
    until true
  end

  -- Inform the world after three seconds
  timer.performWithDelay(3000, world.playerDied)
end

-- Fires a 'killAll' event
function Events.killAll()
  -- Inform each entity
  for i, entity in ipairs(resources.entities) do
    repeat
      -- Ignore destroyed or uninitialized enemies
      if not entity.initialized or entity.destroyed then
        break
      end

      -- Fire event
      entity:killAll()
    until true
  end
end

-- Fires a 'slowerEnemies' event
function Events.slowerEnemies()
  -- Inform each entity
  for i, entity in ipairs(resources.entities) do
    repeat
      -- Ignore destroyed or uninitialized enemies
      if not entity.initialized or entity.destroyed then
        break
      end

      -- Fire event
      entity:slow()
    until true
  end

  -- Speed is now over
  speed = false
end

-- Fires a 'fasterEnemies' event
function Events.fasterEnemies()
  -- Ignore if speed is already activated
  if speed then
    return
  end

  -- Flip the "fast" flag
  speed = true

  -- Inform each entity
  for i, entity in ipairs(resources.entities) do
    repeat
      -- Ignore destroyed or uninitialized enemies
      if not entity.initialized or entity.destroyed then
        break
      end

      -- Fire event
      entity:fast()
    until true
  end

  -- Disable in five seconds
  timer.performWithDelay(5000, Events.slowerEnemies)
end

-- Fires a lurcher event
function Events.lurcher(crate)
  -- Get the lurcher
  local lurcher = resources.getEntityByID(crate.lurcherId)

  -- Attack
  lurcher:attack()
end

return Events
