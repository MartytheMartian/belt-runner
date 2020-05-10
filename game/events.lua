Events = {}

Events.speed = false
Events.kill = false
Events.stopped = false
Events.fireRate = 30
Events.points = 0
Events.playerDied = false
local world = nil
local resources = nil
local pointCounter = nil
local speedFrame = 0
local killFrame = 0
local rateFrame = 0

-- Use hook method for injection to break circular dependencies
function Events.hook(w, r)
  -- Hook items
  world = w
  resources = r

  -- Reset variables
  Events.speed = false
  Events.kill = false
  Events.stopped = false
  Events.fireRate = 30
  Events.points = 0
  Events.playerDied = false
  speedFrame = 0
  killFrame = 0
  rateFrame = 0

  -- Setup point counter
  pointCounter = display.newText("0", 1284, 50, native.systemFont, 32)
  pointCounter:setFillColor(0.82, 0.86, 1)
end

-- Fires a 'playerDied' event
function Events.playerDied()
  -- Set the stopped flag
  Events.stopped = true

  -- Stop the world
  world.stop()

  -- Inform the world after three seconds
  timer.performWithDelay(3000, world.playerDied)
end

-- Fires an 'exit' event
function Events.exit()
  -- Get the player and let it know
  local player = resources.getEntityByID("player")
  player:exit()

  -- Inform the world after ten seconds
  timer.performWithDelay(10000, world.exit)
end

-- Adds points to the player's score.
function Events.addPoints(pts)
  Events.points = Events.points + pts
  pointCounter.text = Events.points
end

-- Fires a 'killAll' event
function Events.killAll()
  -- Trigger flag
  Events.kill = true
  killFrame = 0
end

-- Fires a 'fasterEnemies' event
function Events.fasterEnemies()
  -- Flip the "fast" flag
  Events.speed = true
  speedFrame = 0
end

-- Fires a 'fast recharge rate' event
function Events.fastRecharge()
  -- Set fire rate
  Events.fireRate = 10
  rateFrame = 0
end

-- Fires a 'slow recharge rate' event
function Events.slowRecharge()
  -- Set fire rate
  Events.fireRate = 60
  rateFrame = 0
end

-- Fires a lurcher event
function Events.lurcher(crate)
  -- Get the lurcher
  local lurcher = resources.getEntityByID(crate.lurcherId)

  -- Attack
  lurcher:attack()
end

-- Fires a shield event
function Events.shield(crate)
  -- Get the player
  local player = resources.getEntityByID("player")

  -- Heal the player
  player:shield()
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
  -- Track kill flag
  if Events.kill then
    if killFrame > 1 then
      Events.kill = false
    else
      killFrame = killFrame + 1
    end
  end

  -- Track speed flag
  if Events.speed then
    if speedFrame > 120 then
      Events.speed = false
    else
      speedFrame = speedFrame + 1
    end
  end

  -- Track rate flag
  if Events.fireRate ~= 30 then
    if rateFrame > 300 then
      Events.fireRate = 30
    else
      rateFrame = rateFrame + 1
    end
  end

  -- Ensure point counter is at the front
  pointCounter:toFront()
end

return Events
