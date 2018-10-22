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

-- Handles player death
local function playerDied()
  -- Get the turret
  local turret = resources.getEntityByID("turret")

  -- Kill the turret
  turret.release()
end

-- Initialize the world
function M.initialize(level)
  -- Read each graphic
  for i, graphic in ipairs(level.graphics) do
    resources.createGraphic(graphic)
  end

  -- Read each entity
  for i, entity in ipairs(level.entities) do
    resources.createEntity(entity)
  end

  -- Initialize the audio
  gameAudio.initializeAudio()

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
        if entity.delay <= frames then
          entity.initialize()
        else
          break
        end
      end

      -- Detect collision if necessary
      if entity.collidable then
        -- Determine if collided with something
        local collider = collision.detectCollision(entity, resources.entities)

        -- Let each entity know it collided with something
        if collider ~= nil then
          entity.collided(collider)
          collider.collided(entity)
        end
      end

      -- Update the entity
      entity.update()
    until true
  end
end

-- Handle touch events in the world
function M.touch(x, y)
  -- Touch thorttlin. One a half a second for now.
  if frames - lastTouchFrame < 30 then
    return
  end

  -- Get the player
  local player = resources.getEntityByID("player")

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

-- Relase the world
function M.release()
  if not initialized then
    return
  end

  -- Reset initialized status
  initialized = false

  -- Release each entity
  for i, entity in ipairs(resources.entities) do
    entity.release()
  end

  -- Release the audio
  gameAudio.disposeAudio()

end

-- Return the world
return M
