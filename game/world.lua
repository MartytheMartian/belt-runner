local collision = require("game.collision")
local resources = require("game.resources")
local weapon = require("game.weapon")
local gameAudio = require("game.sounds")

-- Exposed properties of the world
local M = {}

-- Is the level initialized
local initialized = false

-- Current frame count
local frames = 0

-- Track the last frame the player touched
local lastTouchFrame = -1000

-- Has the player stopped moving
local playerDidStop = false

-- Events
local endEvent = nil

-- Handles player death
local function playerDied()
  -- Get the turret
  local turret = resources.getEntityByID("turret")

  -- Kill the turret
  turret.release()

  -- End the game after three seconds
  if endEvent ~= nil then
    timer.performWithDelay(3000, endEvent)
  end
end

-- Handles when the player has stopped because of death or special enemy interaction
local function playerStopped()
  print("playerStopped called")
  playerDidStop = true

  for i, entity in ipairs(resources.entities) do
    repeat
      entity.handleWorldStoppedMoving()
    until true
  end
end

-- Handles when a powerup (or power down) is activated by destroying a crate
local function cratePowerActivated(crateEntityId)
  local crate = resources.getEntityByID(crateEntityId)
  print("power activated " .. crate.id .. " " .. crate.powerUp)

  -- If the powerup is a lurcher, handle that as a special case since only one specific lurcher will become active.
  --  Otherwise, call handleCratePowerActivated on all entities and let them handle the power if needed
  if (crate.powerUp == "lurcher") then
    local theLurcher = resources.getEntityByID(crate.lurcherId)
    theLurcher.handleCratePowerActivated(crate.powerUp)
  else
    for i, entity in ipairs(resources.entities) do
      repeat
        entity.handleCratePowerActivated(crate.powerUp)
        if (crate.powerUp == "fasterEnemies") then
          timer.performWithDelay(5000, setNormalEnemySpeed)
        end
      until true
    end
  end
end

local function setNormalEnemySpeed()
  for i, entity in ipairs(resources.entities) do
    repeat
      entity.handleCratePowerActivated("normalSpeedEnemies")
    until true
  end
end

-- Initialize the world with a level and 'end' hook
function M.initialize(level, gameOver)
  -- Set game over hook as the end event
  endEvent = gameOver

  -- Set all defaults
  initialized = false
  frames = 0
  lastTouchFrame = -1000

  -- Initialize the audio
  gameAudio.initializeAudio()

  -- Setup initial resources
  resources.setup()

  -- Read each graphic
  for i, graphic in ipairs(level.graphics) do
    resources.createGraphic(graphic)
  end

  -- Read each entity
  for i, entity in ipairs(level.entities) do
    resources.createEntity(entity)
    -- Add crate events to any items that are crates
    if (entity.type == "crate") then
      local crate = resources.getEntityByID(entity.id)
      crate.setPowerActivatedHandler(cratePowerActivated)
    end
  end

  -- Prepare 10 missles
  for i = 1, 10 do
    -- Create the missle
    local missle = weapon.createMissle("M" .. i)

    -- Add the missle
    resources.createEntity(missle)

    -- Initialize the missle. Missles do not spawn on initialize.
    resources.getEntityByID(missle.id).initialize()
  end

  -- Get the player
  local player = resources.getEntityByID("player")

  -- Set player events
  player.setDiedHandler(playerDied)
  player.setStopHandler(playerStopped)

  -- Start playing background music
  gameAudio.playBackgroundMusic()

  -- Set the world as initialized
  initialized = true
end

-- Update the world
function M.update()
  if not initialized then
    return
  end

  -- Update the frame count
  frames = frames + 1

  -- Update each entity
  for i, entity in ipairs(resources.entities) do
    repeat
      -- Do not update destroyed entities
      if entity.destroyed then
        break
      end

      -- Initialize the entity if necessary
      if not entity.initialized then
        if entity.delay <= frames and not playerDidStop then
          entity.initialize()
        else
          break
        end
      end

      -- Detect collision if necessary
      if entity.collidable then
        -- Determine if collided with something
        local collider = collision.detectCollision(entity, resources.entities)

        -- Let the entity know it collided if necessary
        if collider ~= nil then
          entity.collided(collider)

          -- Let the collider know if necessary
          if collider.canCollide(entity.type) then
            collider.collided(entity)
          end
        end
      end

      -- Update the entity
      entity.update()
    until true
  end
end

-- Handle touch events in the world
function M.touch(x, y)
  -- Touch thorttling. One a half a second for now.
  if frames - lastTouchFrame < 30 then
    return
  end

  -- Get the player
  local player = resources.getEntityByID("player")

  -- Do nothing if the player is dead
  if player.destroyed then
    return
  end

  -- Prepare to read a missle
  local missle = nil

  -- Find the next available missle entity
  for i = 1, 10 do
    repeat
      local next = resources.getEntityByID("M" .. i)

      -- Not available if not destroyed
      if not next.destroyed then
        break
      end

      -- Ready
      missle = next
    until true
  end

  -- Do nothing if there are no available missles
  if missle == nil then
    return
  end

  -- Create a missle
  weapon.fireMissle(missle, player.position(), {x = x, y = y})

  -- Turret should match missle rotation
  resources.getEntityByID("turret").rotate(missle.position().rotation)

  -- Update the last successful touch
  lastTouchFrame = frames
end

-- Release the world
function M.release()
  if not initialized then
    return
  end

  -- Reset initialized status
  initialized = false

  playerDidStop = false

  -- Release each entity
  for i, entity in ipairs(resources.entities) do
    entity.release()
  end

  -- Clear out resources
  resources.clear()

  -- Release the audio
  gameAudio.disposeAudio()
end

-- Return the world
return M
