local Collision = require("game.collision")
local Common = require("game.common")
local Events = require("game.events")
local Resources = require("game.resources")
local Sound = require("game.sound")
local Weapon = require("game.weapon")

-- Exposed properties of the world
local World = {}

-- Is the level initialized
local initialized = false

-- Is the level stopped
local stopped = false

-- Current frame count
local frames = 0

-- Track the last frame the player touched
local lastTouchFrame = -1000

-- Call this when the game is 'over'
local endEvent = nil

-- Handles player death
function World.playerDied()
  if endEvent ~= nil then
    endEvent()
  end
end

-- Called when the game is 'stopped'
function World.stop()
  stopped = true
end

-- Initialize the world with a level and 'end' hook
function World.initialize(level, gameOver)
  -- Set game over hook as the end event
  endEvent = gameOver

  -- Set all defaults
  initialized = false
  frames = 0
  lastTouchFrame = -1000

  -- Initialize the audio
  Sound.initialize()

  -- Setup initial resources
  Resources.setup()

  -- Read each graphic
  for i, graphic in ipairs(level.graphics) do
    Resources.createGraphic(graphic)
  end

  -- Read each entity
  for i, entity in ipairs(level.entities) do
    Resources.createEntity(entity)
  end

  -- Prepare 10 missiles
  for i = 1, 10 do
    -- Create the missile
    local missile = Weapon.createMissile("M" .. i)

    -- Add the missile
    Resources.createEntity(missile)

    -- Initialize the missile. Missiles do not spawn on initialize.
    Resources.getEntityByID(missile.id):initialize()
  end

  -- Prepare 10 orbs
  for i = 1, 10 do
    -- Create the orb
    local orb = Weapon.createOrb("O" .. i)

    -- Add the orb
    Resources.createEntity(orb)

    -- Initialize the orb. Orbs do no spawn on initialize
    Resources.getEntityByID(orb.id):initialize()
  end

  -- Inject the world and resources for events processing
  Events.hook(World, Resources)

  -- Inject the world and resources for common use
  -- This breaks lua cyclical "import"
  Common.hook(World, Resources)

  -- Set the world as initialized
  initialized = true

  -- Process one update cycle to get everything loaded
  World.update()

  -- Start playing background music
  Sound.playBackground()
end

-- Update the world
function World.update()
  if not initialized then
    return
  end

  -- Update the frame count
  frames = frames + 1

  -- Update each entity
  for i, entity in ipairs(Resources.entities) do
    repeat
      -- Do not update destroyed entities
      if entity.destroyed then
        break
      end

      -- Initialize the entity if necessary
      if not entity.initialized then
        if entity.delay <= frames and not stopped then
          entity:initialize()
        else
          break
        end
      end

      -- Detect collision if necessary
      if entity.collidable then
        -- Determine if collided with something
        local collider = Collision.detectCollision(entity, Resources.entities)

        -- Let the entity know it collided if necessary
        if collider ~= nil then
          entity:collided(collider)

          -- Let the collider know if necessary
          if collider:canCollide(entity.type) then
            collider:collided(entity)
          end
        end
      end

      -- Update the entity
      entity:update()
    until true
  end

  -- Update events
  Events.update()
end

-- Handle touch events in the world
function World.touch(x, y)
  -- Touch thorttling. One a half a second for now.
  if frames - lastTouchFrame < Events.fireRate then
    return
  end

  -- Get the player
  local player = Resources.getEntityByID("player")

  -- Do nothing if the player is dead
  if player.destroyed then
    return
  end

  -- Prepare to read a missile
  local missile = nil

  -- Find the next available missile entity
  for i = 1, 10 do
    repeat
      local next = Resources.getEntityByID("M" .. i)

      -- Not available if not destroyed
      if not next.destroyed then
        break
      end

      -- Ready
      missile = next
    until true
  end

  -- Do nothing if there are no available missiles
  if missile == nil then
    return
  end

  -- Create a missile
  Weapon.fireMissile(missile, player:position(), {x = x, y = y})

  -- Turret should match missile rotation
  Resources.getEntityByID("turret"):rotate(missile:position().rotation)

  -- Update the last successful touch
  lastTouchFrame = frames
end

-- Release the world
function World.release()
  if not initialized then
    return
  end

  -- Reset initialized status
  initialized = false

  playerDidStop = false

  -- Release each entity
  for i, entity in ipairs(Resources.entities) do
    entity:release()
  end

  -- Clear out resources
  Resources.clear()

  -- Release the audio
  Sound.dispose()
end

-- Return the world
return World
